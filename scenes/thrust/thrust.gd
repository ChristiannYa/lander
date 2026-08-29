class_name Thrust
extends Node3D


const CONE_SCALE_IDLE := 0.3
const CONE_SCALE_MAX := 1.0
const CONE_SCALE_FLICKER := 0.9
const CONE_LERP := 12.0


const SPOT_SCALE_IDLE := 1.0
const SPOT_SCALE_MAX := 10.0
const SPOT_SCALE_FLICKER := 0.15
const SPOT_LERP := 12.0


@onready var cone: MeshInstance3D = $Cone
@onready var spot_light_3d: SpotLight3D = $SpotLight3D


func update_visuals(thrust_on: bool, delta: float):
	_update_cone(thrust_on, delta)
	_update_spot(thrust_on, delta)

func _update_cone(thrust_on: bool, delta: float):
	var targ_scale := CONE_SCALE_IDLE
	if thrust_on:
		targ_scale = CONE_SCALE_MAX + randf_range(-CONE_SCALE_FLICKER, CONE_SCALE_FLICKER)
	cone.scale = cone.scale.lerp(targ_scale * Vector3.ONE, delta * CONE_LERP)

func _update_spot(thrust_on: bool, delta: float):	
	var targ_energy := SPOT_SCALE_IDLE
	if thrust_on:
		targ_energy = SPOT_SCALE_MAX + randf_range(-SPOT_SCALE_FLICKER, SPOT_SCALE_FLICKER)
	spot_light_3d.light_energy = lerpf(spot_light_3d.light_energy, targ_energy, delta * SPOT_LERP)

