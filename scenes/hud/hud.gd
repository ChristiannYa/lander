extends Control

@onready var label: Label = $MargCon/Label

func _ready():
	SignalHub.telemetry_updated.connect(func(tel):
		label.text = str(tel)
	)

