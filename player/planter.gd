extends Node2D

onready var area: Area2D = $Area2D
export var reach: float
onready var reach_sq = reach * reach 
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var crop: AnimatedSprite = $Crop


func _process(_delta):
	global_position = get_global_mouse_position()
	crop.frame = player.inventory.selected_item % 3
	modulate = Color.white if _is_valid() else Color.red


func _input(event):
	if event.is_action_released("plant"):
		if _is_valid():
			EventBus.emit_signal("plant")
		
		queue_free()


func _is_valid() -> bool:
	return (
		area.get_overlapping_areas().empty() and
		global_position.y > 64 and
		global_position.y < 630 and
		global_position.x > 48 and
		global_position.x < 624 and
		global_position.distance_squared_to(player.global_position) < reach_sq
	)
