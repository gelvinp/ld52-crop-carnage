extends Node

onready var pause_menu = $CanvasLayer/PauseMenu
onready var shop = $CanvasLayer/Shop


func _ready():
	$AudioStreamPlayer.play(0)


func _unhandled_input(event):
	if not pause_menu.visible and event.is_action_pressed("pause"):
		pause_menu.visible = true
		get_tree().set_input_as_handled()
		get_tree().paused = true
		GlobalAudio.play("affirmative")
	elif not shop.visible and event.is_action_pressed("shop"):
		shop.visible = true
		get_tree().set_input_as_handled()
		get_tree().paused = true
		GlobalAudio.play("affirmative")
