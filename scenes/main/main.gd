extends Control

var GAME = load("res://scenes/game/game.tscn")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_packed(GAME)
