class_name Plant
extends Node2D

enum TYPE {
	CORN = 0,
	POME = 1,
	PUMP = 2
}

enum STATE {
	GROWING,
	HARVESTABLE,
	DEAD
}

export var growth_time: float
export var max_health: int
export(TYPE) var type

var state = STATE.GROWING

onready var health = max_health
onready var timer: Timer = $Timer
onready var progress: TextureProgress = $TextureProgress
onready var crop: AnimatedSprite = $Crop


func _ready():
	timer.wait_time = growth_time
	timer.start()
	progress.max_value = growth_time
	crop.frame = 3
	GlobalAudio.play("affirmative")


func _process(_delta):
	if state == STATE.GROWING:
		progress.value = growth_time - timer.time_left


func harvest():
	if state == STATE.HARVESTABLE:
		var chance = randf()
		
		if chance <= 0.6:
			EventBus.emit_signal("harvest", type, 2)
		elif chance <= 0.9:
			EventBus.emit_signal("harvest", type, 3)
		else:
			EventBus.emit_signal("harvest", type, 1)
		
		match type:
			TYPE.CORN:
				Score.score += 20
			TYPE.POME:
				Score.score += 20
			TYPE.PUMP:
				Score.score += 50
		
		die()


func die():
	if state != STATE.DEAD:
		state = STATE.DEAD
		queue_free()


func grow_now() -> bool:
	if state == STATE.GROWING:
		timer.start(0.1)
		return true
	
	return false


func _on_Timer_timeout():
	if state == STATE.GROWING:
		state = STATE.HARVESTABLE
		progress.value = growth_time
		crop.frame = type


func damage(amount):
	health -= amount
	
	if health <= 0:
		die()
