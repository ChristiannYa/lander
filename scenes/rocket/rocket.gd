extends RigidBody3D

@export var landing_pad: Node3D

@onready var thrust: Thrust = $Thrust
@onready var thrust_l: Thrust = $ThrustL
@onready var thrust_r: Thrust = $ThrustR

const THRUST_FORCE = 15.0
const TORQUE_STRENGTH = 2.0

func _physics_process(delta: float):
	var thrust_applied: bool = Input.is_action_pressed("thust")
	if thrust_applied:
		apply_central_force(global_transform.basis.y * THRUST_FORCE)

	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	var torque: Vector3 = global_transform.basis.x * pitch * TORQUE_STRENGTH
	torque += global_transform.basis.y * yaw * TORQUE_STRENGTH	
	apply_torque(torque)

	emit_telemtry()

	thrust.update_visuals(thrust_applied, delta)
	thrust_l.update_visuals(thrust_applied, delta)
	thrust_r.update_visuals(thrust_applied, delta)

func emit_telemtry():
	var tel := RocketTelemetry.new()
	tel.speed = linear_velocity.length()
	tel.ver_speed = linear_velocity.y
	tel.tilt = rad_to_deg(global_transform.basis.y.angle_to(Vector3.UP))
	tel.spin = angular_velocity.length()

	if landing_pad: 
		tel.distance = global_position.distance_to(landing_pad.position)
		tel.height_delta = global_position.y - landing_pad.global_position.y

	SignalHub.emit_telemetry_updated(tel)
