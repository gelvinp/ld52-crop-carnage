extends Node

var score = 0
var high_score = 0


func _ready():
	pass


func start_game():
	score = 0


func end_game():
	if score > high_score:
		high_score = score
