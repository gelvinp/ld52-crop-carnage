class_name Plant
extends Node2D

var harvestable := true


func harvest():
	if harvestable:
		harvestable = false
		queue_free()
