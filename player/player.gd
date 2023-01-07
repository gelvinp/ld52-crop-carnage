class_name Player
extends KinematicBody2D

export var speed: float
var planter_pck := preload("res://player/planter.tscn")
onready var scythe := $Scythe

var attacking := false
var selected_plantable := -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	if not attacking:
		var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		move_and_slide(movement * speed)


func _unhandled_input(event):
	if event.is_action_pressed("plant") and selected_plantable >= 0:
		var planter = planter_pck.instance()
		get_tree().get_root().add_child(planter)
	elif event.is_action_pressed("attack") and not attacking:
		attacking = true
		scythe.attack(self, "_attack_finished")
	elif event.is_action_pressed("item1"):
		selected_plantable = Plant.TYPE.CORN
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item2"):
		selected_plantable = Plant.TYPE.POME
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item3"):
		selected_plantable = Plant.TYPE.PUMP
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("equip"):
		selected_plantable = -1
		get_tree().set_input_as_handled()


func _attack_finished():
	attacking = false
