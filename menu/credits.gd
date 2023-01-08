extends Control


func _on_Button_pressed():
	GlobalAudio.play("affirmative")
	get_tree().change_scene("res://menu/menu.tscn")
