extends Node

onready var pause_menu = $CanvasLayer/PauseMenu


func _unhandled_input(event):
	if not pause_menu.visible and event.is_action_pressed("pause"):
		pause_menu.visible = true
		get_tree().paused = true
		get_tree().set_input_as_handled()
