class_name EnemyMelee
extends Node2D

onready var area: Area2D = $Area2D
export var damage: float


func attack_player():
	for a in area.get_overlapping_bodies():
		if a.name == "Player":
			a.health -= damage


func attack_plants():
	for a in area.get_overlapping_areas():
		var potential = a.get_parent()
		
		if potential is Plant:
			potential.damage(damage)
			return
