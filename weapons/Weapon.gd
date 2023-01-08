class_name Weapon
extends Node2D

enum TYPE {
	SCYTHE = 0,
	CORN = 1,
	POME = 2,
	PUMP = 3
}

const names = ["Scythe", "Corn", "Pomegranate", "Pumpkin"]

var ammo := [1, 0, 0, 0]
onready var scythe := $Scythe
onready var timer: Timer = $Timer

var equipped = TYPE.SCYTHE

const proj_corn_pck = preload("res://weapons/ProjCorn.tscn")
const proj_pome_pck = preload("res://weapons/ProjPome.tscn")
const proj_pump_pck = preload("res://weapons/ProjPump.tscn")


func _ready():
	EventBus.connect("ammunize", self, "gain_ammo")


func _unhandled_input(event):
	if event.is_action_pressed("weapon_next"):
		select_in_direction(1)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("weapon_prev"):
		select_in_direction(-1)
		get_tree().set_input_as_handled()


func gain_ammo(type, quantity):
	ammo[type] += quantity
	equip(type)


func equip(type):
	var weapon = names[type]
	
	if type != TYPE.SCYTHE:
		weapon += " (" + str(ammo[type]) + ")"
	
	equipped = type
	
	EventBus.emit_signal("equip", weapon)


func able_to_attack():
	return timer.is_stopped()


func attack():
	match equipped:
		TYPE.SCYTHE:
			scythe.attack(self, "")
			scythe.position = (global_position + Vector2(0, -32)).direction_to(get_global_mouse_position()) * Vector2(24, 32) + Vector2(0, -16)
			timer.start(0.5)
			return
		TYPE.CORN:
			var weapon: Projectile = proj_corn_pck.instance()
			weapon.speed = 3
			weapon.damage = 10
			get_tree().get_root().add_child(weapon)
			weapon.global_position = global_position + Vector2(0, -32)
			weapon.direction = weapon.global_position.direction_to(get_global_mouse_position())
			spend_ammo()
			timer.start(0.5)
		TYPE.POME:
			var weapon: Projectile = proj_pome_pck.instance()
			weapon.speed = 7
			weapon.damage = 7
			get_tree().get_root().add_child(weapon)
			weapon.global_position = global_position + Vector2(0, -32)
			weapon.direction = weapon.global_position.direction_to(get_global_mouse_position())
			spend_ammo()
			timer.start(0.25)
		TYPE.PUMP:
			var weapon: Explosive = proj_pump_pck.instance()
			weapon.global_position = global_position + Vector2(0, -32)
			get_tree().get_root().add_child(weapon)
			weapon.direction = weapon.global_position.direction_to(get_global_mouse_position())
			spend_ammo()
			timer.start(1)


func spend_ammo():
	if equipped != TYPE.SCYTHE:
		ammo[equipped] = max(0, ammo[equipped] - 1)
		
		if ammo[equipped] == 0:
			equip(TYPE.SCYTHE)
		else:
			equip(equipped)


func select_in_direction(direction):
	var iterations = 0
	var next = equipped
	
	while true:
		next += direction
		
		if next > 3:
			next -= 4
		elif next < 0:
			next += 4
		
		if iterations > 4:
			break
		
		iterations += 1
		
		if ammo[next] > 0:
			equip(next)
			break
