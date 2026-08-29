extends Camera3D


const OFFSET := Vector3(0, 6, 10)
const FOLLOW_SPEED := 3.0


@export var rocket: Node3D


func _ready():
	if rocket:
		global_position = rocket.global_position + OFFSET

func _physics_process(delta: float):
	if not rocket: return
	var desired: Vector3 = rocket.global_position + OFFSET
	global_position = global_position.lerp(desired, delta * FOLLOW_SPEED)
	look_at(rocket.global_position)
