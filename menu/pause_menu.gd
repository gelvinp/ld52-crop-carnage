extends PanelContainer


func _on_Button_pressed():
	visible = false
	get_tree().paused = false


func _unhandled_input(event):
	if visible and event.is_action_pressed("pause"):
		visible = false
		get_tree().paused = false
		get_tree().set_input_as_handled()


func _on_Button2_pressed():
	get_tree().change_scene("res://menu/menu.tscn")
