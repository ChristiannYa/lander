extends Node

signal telemetry_updated(tel: RocketTelemetry)
signal game_over

func emit_telemetry_updated(tel: RocketTelemetry):
	telemetry_updated.emit(tel)

func emit_game_over():
	game_over.emit()
