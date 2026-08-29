class_name Wind
extends Node3D

const ANGLE_VAR := 20.0
const TURN_RATE := 2.0
const BASE_FORCE := 1.2

var wind_force := Vector3.ZERO

var _base_angle := 0.0
var _cur_angle := 0.0

func _ready():
	_base_angle = randf_range(0, TAU)
	_cur_angle = _base_angle
	rotation.y = _base_angle

func _physics_process(delta: float):
	rotation.y = lerp(rotation.y, _cur_angle, delta * TURN_RATE)
	wind_force = transform.basis.z * BASE_FORCE

func _on_timer_timeout() -> void:
	_cur_angle = _base_angle + deg_to_rad(randf_range(-ANGLE_VAR, ANGLE_VAR))
