extends Node2D


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://menu/credits.tscn")
