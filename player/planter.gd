extends Node2D

onready var area: Area2D = $Area2D
export var reach: float
onready var reach_sq = reach * reach 
onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]


func _process(_delta):
	global_position = get_global_mouse_position()


func _input(event):
	if event.is_action_released("plant"):
		if _is_valid():
			EventBus.emit_signal("plant")
		
		queue_free()
	elif event is InputEventMouseMotion:
		modulate = Color.orange if _is_valid() else Color.red


func _is_valid() -> bool:
	return (
		area.get_overlapping_areas().empty() and
		global_position.distance_squared_to(player.global_position) < reach_sq
	)
