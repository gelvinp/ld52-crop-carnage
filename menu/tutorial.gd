extends Control


func _on_Button_pressed():
	GlobalAudio.play("affirmative")
	get_tree().change_scene("res://menu/menu.tscn")


func _on_TabContainer_tab_changed(_tab):
	GlobalAudio.play("affirmative")
