class_name Enemy
extends KinematicBody2D

enum TYPE {
	SWARMER,
	SHOOTER,
	PEST
}

const skin := {
	TYPE.SWARMER: preload("res://enemies/enemy-yellow.tres"),
	TYPE.SHOOTER: preload("res://enemies/enemy-orange.tres"),
	TYPE.PEST: preload("res://enemies/enemy-red.tres")
}

export var speed: float
export var max_health: float
export(TYPE) var type
onready var animation: AnimatedSprite = $AnimatedSprite
onready var timer: Timer = $Timer
onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]

var attacking := false
var target: Node2D
var distance := 0.0
onready var health := max_health

const bullet_pck = preload("res://weapons/ProjBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.frames = skin[type]
	animation.play("idle")
	choose_target()


func _physics_process(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		choose_target()
	
	if distance == 0.0:
		if animation.animation != "idle":
			animation.play("idle")
		
		return
	
	if not attacking:
		if global_position.distance_squared_to(target.global_position) < distance:
			_attack()
			return
		
		var movement = global_position.direction_to(target.global_position)
		move_and_slide(movement * speed)
		
		if movement.is_equal_approx(Vector2.ZERO):
			if animation.animation != "idle":
				animation.play("idle")
		else:
			if animation.animation != "walk":
				animation.play("walk")
			
			if movement.x != 0:
				animation.scale.x = sign(movement.x)


func _attack():
	if not timer.is_stopped():
		return
	
	attacking = true
	#scythe.attack(self, "")
	animation.play("attack")
	animation.connect("animation_finished", self, "_attack_finished", [], CONNECT_ONESHOT)
	
	if type == TYPE.SHOOTER:
		# Shoot a bullet
		var weapon: Projectile = bullet_pck.instance()
		weapon.speed = 7
		weapon.damage = 10
		get_tree().get_root().add_child(weapon)
		weapon.global_position = global_position + Vector2(0, -32)
		weapon.direction = weapon.global_position.direction_to(player.global_position)
		weapon.collision_mask = 3
	
	# Find correct place for scythe
#	var mouse_offset = get_global_mouse_position() - global_position
#	if abs(mouse_offset.x) >= abs(mouse_offset.y):
#		# Horizontal
#		scythe.position.y = -30
#		scythe.position.x = 16 * sign(mouse_offset.x)
#	else:
#		# Vertical
#		scythe.position.x = 0
#		scythe.position.y = 30 * sign(mouse_offset.y) - 30


func _attack_finished():
	attacking = false
	animation.play("idle")
	timer.start()


func choose_target():
	match type:
		TYPE.SWARMER:
			target = player
			distance = 700.0
		TYPE.SHOOTER:
			target = player
			distance = 20000.0
			timer.wait_time = 2.0
		TYPE.PEST:
			var plants = get_tree().get_nodes_in_group("plant")
			
			if not plants.empty():
				target = plants[randi() % plants.size()]
				distance = 100
			else:
				distance = 0.0


func damage(amount):
	health -= amount
	
	if health <= 0:
		queue_free()
