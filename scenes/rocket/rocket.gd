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

var _last_speed := 0.0

func _physics_process(delta: float):
	var thrust_applied: bool = Input.is_action_pressed("thust")
	if thrust_applied:
		apply_central_force(global_transform.basis.y * THRUST_CENT_FORCE)

	var thrust_l_applied: bool = Input.is_action_pressed("roll_left")
	var thrust_r_applied: bool = Input.is_action_pressed("roll_right")

	if thrust_l_applied: apply_side_thrust(thrust_l)
	if thrust_r_applied: apply_side_thrust(thrust_r)

	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	var torque: Vector3 = global_transform.basis.x * pitch * TORQUE_STRENGTH
	torque += global_transform.basis.y * yaw * TORQUE_STRENGTH	
	apply_torque(torque)

	emit_telemtry()

	thrust.update_effects(thrust_applied, delta)
	thrust_l.update_effects(thrust_l_applied, delta)
	thrust_r.update_effects(thrust_r_applied, delta)

	_last_speed = linear_velocity.length()

func apply_side_thrust(thruster: Thrust):
	var ofs: Vector3 = thruster.global_position - global_position
	apply_force(global_transform.basis.y * THRUST_SIDE_FORCE, ofs)

func get_tilt() -> float:
	return rad_to_deg(global_transform.basis.y.angle_to(Vector3.UP))

func emit_telemtry():
	var tel := RocketTelemetry.new()
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
		timer.start()
		set_physics_process(false)

func _on_sleeping_state_changed():
	if sleeping:
		if is_physics_processing():
			if get_tilt() < MAX_LANDING_TITLT:
				print("LANDED")
			else: 
				print("CRASHED")
			set_physics_process(false)

func _on_timer_timeout() -> void:
	freeze = true
