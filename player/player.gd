class_name Player
extends KinematicBody2D

export var speed: float
var planter_pck := preload("res://player/planter.tscn")
var waterer_pck := preload("res://player/waterer.tscn")
onready var scythe := $Scythe
onready var inventory: Inventory = get_tree().get_nodes_in_group("inventory")[0]

var attacking := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	if not attacking:
		var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		move_and_slide(movement * speed)


func _unhandled_input(event):
	if event.is_action_pressed("plant") and inventory.selected_item != Inventory.ITEM.NOTHING:
		var planter = waterer_pck.instance() if inventory.selected_item == Inventory.ITEM.WATER else planter_pck.instance()
		get_tree().get_root().add_child(planter)
	elif event.is_action_pressed("attack") and not attacking:
		attacking = true
		scythe.attack(self, "_attack_finished")


func _attack_finished():
	attacking = false
