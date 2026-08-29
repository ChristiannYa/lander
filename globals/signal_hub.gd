extends Node

signal telemetry_updated(tel: RocketTelemetry)
signal game_over(resl: LandingResult)

func emit_telemetry_updated(tel: RocketTelemetry):
	telemetry_updated.emit(tel)

func emit_game_over(resl: LandingResult):
	game_over.emit(resl)
