extends RigidBody3D

const THRUST_FORCE = 15.0
const TORQUE_STRENGTH = 2.0

func _physics_process(_delta: float):
	if Input.is_action_pressed("thust"):
		apply_central_force(global_transform.basis.y * THRUST_FORCE)

	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	var torque: Vector3 = global_transform.basis.x * pitch * TORQUE_STRENGTH
	torque += global_transform.basis.y * yaw * TORQUE_STRENGTH
	
	apply_torque(torque)

