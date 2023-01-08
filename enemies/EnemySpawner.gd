extends Node

export(NodePath) var spawn_node_path
export(NodePath) var spawn_path_node_path

export var initial_max_wait: float
export var initial_min_wait: float
export var final_max_wait: float
export var final_min_wait: float
export var wait_decrease_speed: float

onready var spawn_node: Node2D = get_node(spawn_node_path)
onready var spawn_path_node: PathFollow2D = get_node(spawn_path_node_path)
onready var timer: Timer = $Timer
onready var max_wait := initial_max_wait
onready var min_wait := initial_min_wait

const enemy_pck = preload("res://enemies/enemy.tscn")

var first_spawn = true


func _ready():
	EventBus.connect("harvest", self, "_on_harvest", [], CONNECT_ONESHOT)
	timer.start(initial_max_wait)


func _on_harvest(_a, _b):
	timer.start(3)


func wait():
	timer.start(rand_range(min_wait, max_wait))


func _on_Timer_timeout():
	spawn()
	
	if not first_spawn:
		if randf() > 0.7:
			spawn()
		if randf() > 0.95:
			spawn()
	
	first_spawn = false
	
	var decrease = rand_range(1, wait_decrease_speed)
	min_wait = max(final_min_wait, min_wait - decrease)
	max_wait = max(final_max_wait, max_wait - decrease)
	wait()


func spawn():
	spawn_path_node.unit_offset = randf()
	var chance = randf()
	var enemy = enemy_pck.instance()
	
	if chance <= 0.5:
		enemy.type = Enemy.TYPE.SWARMER
		enemy.max_health = floor(rand_range(2, 4.2)) * 10
		enemy.speed = rand_range(60, 75)
	elif get_tree().get_nodes_in_group("plant").empty() or chance <= 0.8:
		enemy.type = Enemy.TYPE.SHOOTER
		enemy.max_health = floor(rand_range(2.5, 4.8)) * 10
		enemy.speed = rand_range(50, 65)
	else:
		enemy.type = Enemy.TYPE.PEST
		enemy.max_health = floor(rand_range(1.8, 3.8)) * 10
		enemy.speed = rand_range(65, 80)
	
	enemy.global_position = spawn_path_node.global_position
	spawn_node.add_child(enemy)
