class_name Projectile
extends KinematicBody2D

export var speed: float
export var direction: Vector2
export var damage: float


func _physics_process(_delta):
	var collision = move_and_collide(direction * speed)
	if collision != null:
		if collision.collider.name == "Enemy":
			collision.collider.damage(damage)
		elif collision.collider.name == "Player":
			collision.collider.set_health(collision.collider.get_health() - damage)
		
		queue_free()
