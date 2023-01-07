class_name Plant
extends Node2D

enum TYPE {
	CORN,
	POME,
	PUMP
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


func _ready():
	timer.wait_time = growth_time
	timer.start()
	progress.max_value = growth_time


func _process(_delta):
	if state == STATE.GROWING:
		progress.value = growth_time - timer.time_left


func harvest():
	if state == STATE.HARVESTABLE:
		die()


func die():
	if state != STATE.DEAD:
		state = STATE.DEAD
		queue_free()


func grow_now():
	if state == STATE.GROWING:
		timer.start(0.1)


func _on_Timer_timeout():
	if state == STATE.GROWING:
		state = STATE.HARVESTABLE
