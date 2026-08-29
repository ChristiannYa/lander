extends Control

@onready var label: Label = $MargCon/Label
@onready var game_over_rect: ColorRect = $GameOverRect
@onready var timer: Timer = $Timer
@onready var result_label: Label = $GameOverRect/ResultLabel
@onready var music: AudioStreamPlayer = $Music
@onready var crash_sound: AudioStreamPlayer = $CrashSound
@onready var land_sound: AudioStreamPlayer = $LandSound

func _ready():
	SignalHub.telemetry_updated.connect(func(tel: RocketTelemetry):
		label.text = str(tel)
	)
	SignalHub.game_over.connect(func(resl: LandingResult):
		music.stop()
		match resl.outcome:
			LandingResult.Outcome.LANDED: 
				result_label.text = "LANDED \nScore: %d" % resl.score
				if resl.new_high_score: result_label.text += " NEW BEST"
				land_sound.play(20.0)
			LandingResult.Outcome.CRASHED: 
				result_label.text = "CRASHED"
				crash_sound.play()
			LandingResult.Outcome.LOST: 
				result_label.text = "LOST"
				crash_sound.play()

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
