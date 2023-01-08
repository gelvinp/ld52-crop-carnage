extends Node


signal plant
signal water
signal harvest(type, quantity)
signal ammunize(type, quantity)
signal equip(weapon)
signal silly(text)
signal money(amount)


func _ready():
	randomize()
