extends Control

@onready var label: Label = $MargCon/Label

func _ready():
	SignalHub.telemetry_updated.connect(func(tel):
		label.text = str(tel)
	)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"): GameManager.load_main()

