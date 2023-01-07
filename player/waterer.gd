extends Node2D

onready var area: Area2D = $Area2D
export var reach: float
onready var reach_sq = reach * reach 
onready var player = get_tree().get_nodes_in_group("player")[0]

const blue := Color("a200cfff")
const red := Color("a2ff0000")


func _process(_delta):
	global_position = get_global_mouse_position()
	modulate = blue if _is_valid() else red


func _input(event):
	if event.is_action_released("plant"):
		if _is_valid():
			var overlapping = area.get_overlapping_areas()
			
			var watered = false
			
			for plant in overlapping:
				var potential = plant.get_parent()
				
				if potential is Plant:
					watered = potential.grow_now() or watered
			
			if watered:
				EventBus.emit_signal("water")
		
		queue_free()


func _is_valid() -> bool:
	return global_position.distance_squared_to(player.global_position) < reach_sq
