class_name Explosive
extends Area2D

export var speed: float
export var direction: Vector2
export var distance: float
export var damage: float

onready var dist_sq := distance * distance
onready var start := global_position
onready var animation: AnimationPlayer = $AnimationPlayer


func _physics_process(delta):
	if speed > 0:
		position += speed * direction * delta
		
		if global_position.distance_squared_to(start) >= distance:
			speed = 0
			animation.play("explode")


func explode():
	for body in get_overlapping_bodies():
		if body is Enemy:
			body.damage(damage)
