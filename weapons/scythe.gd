extends Node2D

onready var color: TextureRect = $ColorRect
onready var area: Area2D = $Area2D
onready var anim: AnimationPlayer = $AnimationPlayer


func attack(callback_target: Object, callback: String = ""):
	anim.play("attack")
	
	if callback != "":
		anim.connect("animation_finished", self, "_strip_anim_name", [callback_target, callback], CONNECT_ONESHOT)


func _strip_anim_name(_name, target, callback):
	target.call(callback)


func _do_attack():
	for a in area.get_overlapping_areas():
		var potential = a.get_parent()
		
		if potential is Plant:
			potential.harvest()
	
	for a in area.get_overlapping_bodies():
		if a is Enemy:
			a.damage(10)
