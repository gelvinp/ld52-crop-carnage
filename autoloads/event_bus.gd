extends Node


signal plant
signal water
signal harvest(type, quantity)


func _ready():
	randomize()
