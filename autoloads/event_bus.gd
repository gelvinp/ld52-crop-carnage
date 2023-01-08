extends Node


signal plant
signal water
signal harvest(type, quantity)
signal ammunize(type, quantity)
signal equip(weapon)
signal silly(text)


func _ready():
	randomize()
