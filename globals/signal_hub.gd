extends Node

signal telemetry_updated(tel: RocketTelemetry)

func emit_telemetry_updated(tel: RocketTelemetry):
	telemetry_updated.emit(tel)
