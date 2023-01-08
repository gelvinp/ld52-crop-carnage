class_name Player
extends KinematicBody2D

export var speed: float
var planter_pck := preload("res://player/planter.tscn")
var waterer_pck := preload("res://player/waterer.tscn")
onready var weapon := $Weapon
onready var inventory: Inventory = get_tree().get_nodes_in_group("inventory")[0]
onready var animation: AnimatedSprite = $AnimatedSprite

var attacking := false
var health = 100.0 setget set_health, get_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	if not attacking:
		var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		move_and_slide(movement * speed)
		
		if movement.is_equal_approx(Vector2.ZERO):
			if animation.animation != "idle":
				animation.play("idle")
		else:
			if animation.animation != "walk":
				animation.play("walk")
			
			if movement.x != 0:
				animation.scale.x = sign(movement.x)


func _unhandled_input(event):
	if event.is_action_pressed("plant") and inventory.selected_item != Inventory.ITEM.NOTHING:
		var planter = waterer_pck.instance() if inventory.selected_item == Inventory.ITEM.WATER else planter_pck.instance()
		get_tree().get_root().add_child(planter)
	elif event.is_action_pressed("attack") and not attacking and weapon.able_to_attack():
		attacking = true
		weapon.attack()
		animation.play("attack")
		animation.connect("animation_finished", self, "_attack_finished", [], CONNECT_ONESHOT)


func _attack_finished():
	attacking = false


func set_health(new_health):
	health = clamp(new_health, 0, 100)
	if health == 0:
		print("Death!")


func get_health():
	return health
