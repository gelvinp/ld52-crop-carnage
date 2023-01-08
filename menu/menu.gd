extends Control


func _ready():
	if OS.has_feature("web"):
		$VBoxContainer/GridContainer/QuitButton.queue_free()
		$VBoxContainer/GridContainer.columns = 1


func _on_PlayButton_pressed():
	Score.start_game()
	GlobalAudio.play("affirmative")
	get_tree().change_scene("res://Game.tscn")


func _on_CreditsButton_pressed():
	GlobalAudio.play("affirmative")
	get_tree().change_scene("res://menu/credits.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_TutorialButton_pressed():
	GlobalAudio.play("affirmative")
	get_tree().change_scene("res://menu/tutorial.tscn")
