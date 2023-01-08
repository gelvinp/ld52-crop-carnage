extends MarginContainer

onready var score: Label = $VBoxContainer/VBoxContainer/Score
onready var high_score: Label = $VBoxContainer/VBoxContainer/HighScore


func _ready():
	Score.end_game()
	score.text = "Score: " + str(Score.score)
	high_score.text = "High Score: " + str(Score.high_score)
	$AudioStreamPlayer.play()


func _on_Button_pressed():
	get_tree().change_scene("res://menu/menu.tscn")
