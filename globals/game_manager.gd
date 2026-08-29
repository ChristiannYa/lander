extends Node

const MAIN = preload("res://scenes/main/main.tscn")
const GAME = preload("res://scenes/game/game.tscn")

func load_main(): get_tree().change_scene_to_packed(MAIN)
func load_game(): get_tree().change_scene_to_packed(GAME)
