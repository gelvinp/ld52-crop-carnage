extends Node2D

onready var ysort: YSort = $YSort
var plants = {
	Plant.TYPE.CORN: preload("res://plants/Corn.tscn"),
	Plant.TYPE.POME: preload("res://plants/Pome.tscn"),
	Plant.TYPE.PUMP: preload("res://plants/Pump.tscn"),
}
onready var player: Player = $YSort/Player


func _ready():
	EventBus.connect("plant", self, "_on_plant")


func _on_plant():
	var plant = plants[player.inventory.selected_item % 3].instance()
	plant.global_position = get_global_mouse_position()
	ysort.add_child(plant)
