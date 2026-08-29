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

const SOUND_IDLE := -16.0
const SOUND_MAX := -2.0
const SOUND_PITCH_IDLE := 0.8
const SOUND_PITCH_MAX := 1.7
const SOUND_LERP := 6.0


@onready var cone: MeshInstance3D = $Cone
@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var thrust_sound: AudioStreamPlayer3D = $ThrustSound


func _ready():
	cone.scale = CONE_SCALE_IDLE * Vector3.ONE
	thrust_sound.volume_db = SOUND_IDLE

func update_effects(thrust_on: bool, delta: float):
	_update_cone(thrust_on, delta)
	_update_spot(thrust_on, delta)
	_update_thrust_sound(thrust_on, delta)

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

func _update_thrust_sound(thrust_on: bool, delta: float):
	var target_volume := SOUND_IDLE
	var target_pitch := SOUND_PITCH_IDLE
	if thrust_on:
		target_volume = SOUND_MAX
		target_pitch = SOUND_PITCH_MAX
	thrust_sound.volume_db = lerpf(thrust_sound.volume_db, target_volume, SOUND_LERP * delta)
	thrust_sound.pitch_scale = lerpf(thrust_sound.pitch_scale, target_pitch, SOUND_LERP * delta)

func shut_down():
	thrust_sound.stop()
	spot_light_3d.visible = false
	cone.scale = CONE_SCALE_IDLE * Vector3.ONE
