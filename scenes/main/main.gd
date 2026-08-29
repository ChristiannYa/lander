extends Control

var GAME = load("res://scenes/game/game.tscn")

func _ready():
	get_tree().paused = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"): GameManager.load_game()
