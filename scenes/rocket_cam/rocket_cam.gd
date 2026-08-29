extends Camera3D


const OFFSET := Vector3(0, 6, 10)
const FOLLOW_SPEED := 3.0


@export var rocket: Node3D
@export var landing_pad: Node3D


var _last_dir := Vector3.BACK


func _ready():
	if rocket and landing_pad:
		global_position = get_desired_pos()
		look_at(rocket.global_position)

func _physics_process(delta: float):
	if not rocket or not landing_pad: return
	global_position = global_position.lerp(get_desired_pos(), delta * FOLLOW_SPEED)
	look_at(rocket.global_position)

func get_desired_pos() -> Vector3:
	var to_rocket: Vector3 = rocket.global_position - landing_pad.global_position
	to_rocket.y = 0
	if to_rocket.length() > 1.0: 
		_last_dir = to_rocket.normalized()
	return rocket.global_position + _last_dir * OFFSET.z + Vector3.UP * OFFSET.y
