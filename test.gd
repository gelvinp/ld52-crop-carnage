extends Node2D

onready var ysort: YSort = $YSort
var plant_pck := preload("res://plants/plant.tscn")


func _ready():
	EventBus.connect("plant", self, "_on_plant")


func _on_plant():
	var plant = plant_pck.instance()
	plant.global_position = get_global_mouse_position()
	ysort.add_child(plant)
