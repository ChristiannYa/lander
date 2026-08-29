extends Control

@onready var label: Label = $MargCon/Label
@onready var game_over_rect: ColorRect = $GameOverRect
@onready var timer: Timer = $Timer

func _ready():
	SignalHub.telemetry_updated.connect(func(tel):
		label.text = str(tel)
	)
	SignalHub.game_over.connect(func():
		if !game_over_rect or !timer: return 
		game_over_rect.show()
		timer.start()
	)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"): GameManager.load_main()

# We need to set `Node > Process > Mode=Always`, otherwise the entire tree
# will be paused.
# Once the setting is set, "main" has to handle the tree unpausing at the
# `_ready()` call
func _on_timer_timeout() -> void:
	get_tree().paused = true
