class_name RocketTelemetry
extends RefCounted

var speed := 0.0
var ver_speed := 0.0
var distance := 0.0
var height_delta := 0.0
var tilt := 0.0
var spin := 0.0

func _to_string() -> String:
	return ("Speed: %5.1f m/s\n" + 
			"Vertical Speed: %5.1f m/s\n" + 
			"Distance: %5.1f m\n" + 
			"Height: %5.1f m\n" +
			"Spin: %5.1f rad/s\n" +
			"Tilt: %5.0f deg") % [
				speed, ver_speed, distance, height_delta, spin, tilt
			]
