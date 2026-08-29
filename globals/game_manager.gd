extends Node

const MAIN = preload("res://scenes/main/main.tscn")
const GAME = preload("res://scenes/game/game.tscn")

var _score_data: ScoreData

var high_score: int:
	get: return _score_data.high_score

func _ready():
	_score_data = ScoreData.load_or_create()

func submit_score(score: int) -> bool:
	return _score_data.submit(score)

func load_main(): get_tree().change_scene_to_packed(MAIN)
func load_game(): get_tree().change_scene_to_packed(GAME)
