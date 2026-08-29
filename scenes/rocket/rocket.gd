extends RigidBody3D

@export var landing_pad: Node3D

@onready var thrust: Thrust = $Thrust
@onready var thrust_l: Thrust = $ThrustL
@onready var thrust_r: Thrust = $ThrustR
@onready var timer: Timer = $Timer

const THRUST_CENT_FORCE := 15.0
const THRUST_SIDE_FORCE := 3.0
const TORQUE_STRENGTH := 2.0
const MAX_LANDING_SPEED := 6.0
const MAX_LANDING_TITLT := 10.0
const MAX_FUEL := 2.0
const FUEL_DROP := 50.0

var _last_speed := 0.0
var _fuel := MAX_FUEL
var _out_of_fuel := false
var _fuel_out_y := 0.0

func _physics_process(delta: float):
	if !_out_of_fuel:
		apply_main_thrust(delta)
		apply_side_thrusters(delta)
		apply_rotation()

	check_fuel()
	emit_telemtry()

	_last_speed = linear_velocity.length()

func apply_rotation():
	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	var torque: Vector3 = global_transform.basis.x * pitch * TORQUE_STRENGTH
	torque += global_transform.basis.y * yaw * TORQUE_STRENGTH	
	apply_torque(torque)

func apply_main_thrust(delta: float):
	var applied: bool = Input.is_action_pressed("thust")
	if applied:
		_fuel -= delta
		apply_central_force(global_transform.basis.y * THRUST_CENT_FORCE)
	thrust.update_effects(applied, delta)

func apply_side_thrusters(delta: float):
	var l_applied: bool = Input.is_action_pressed("roll_left")
	var r_applied: bool = Input.is_action_pressed("roll_right")
	if l_applied: apply_side_thrust(thrust_l, delta)
	if r_applied: apply_side_thrust(thrust_r, delta)
	thrust_l.update_effects(l_applied, delta)
	thrust_r.update_effects(r_applied, delta)

func apply_side_thrust(thruster: Thrust, delta: float):
	_fuel -= delta / 3
	var ofs: Vector3 = thruster.global_position - global_position
	apply_force(global_transform.basis.y * THRUST_SIDE_FORCE, ofs)

func get_tilt() -> float:
	return rad_to_deg(global_transform.basis.y.angle_to(Vector3.UP))

func check_fuel():
	if !_out_of_fuel and _fuel <= 0.0:
		_out_of_fuel = true
		_fuel = 0
		_fuel_out_y = global_position.y
		thrust.shut_down()
		thrust_l.shut_down()
		thrust_r.shut_down()

	if _out_of_fuel and global_position.y < _fuel_out_y - FUEL_DROP:
		print("Lost in space...")
		game_over()
		freeze = true

func emit_telemtry():
	var tel := RocketTelemetry.new()
	tel.fuel = _fuel
	tel.speed = linear_velocity.length()
	tel.ver_speed = linear_velocity.y
	tel.tilt = get_tilt()
	tel.spin = angular_velocity.length()

	if landing_pad: 
		tel.distance = global_position.distance_to(landing_pad.position)
		tel.height_delta = global_position.y - landing_pad.global_position.y

	SignalHub.emit_telemetry_updated(tel)

# Requires `RigidBody3D > Contact Monitor=on` along with `.max_contacts_reported=1`
func _on_body_entered(body: Node):
	if _last_speed > MAX_LANDING_SPEED:
		print("CRASHED")
		timer.start()
		game_over()

func _on_sleeping_state_changed():
	if sleeping:
		if is_physics_processing():
			if get_tilt() < MAX_LANDING_TITLT:
				print("LANDED")
			else: 
				print("CRASHED")
			game_over()

func _on_timer_timeout() -> void:
	freeze = true

func game_over():
	set_physics_process(false)
	SignalHub.emit_game_over()
