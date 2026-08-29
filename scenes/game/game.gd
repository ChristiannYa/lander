extends Node

var MAIN = load("res://scenes/main/main.tscn")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(MAIN)
