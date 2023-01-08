extends Area2D

enum TYPE {
	COIN,
	BANDAGE,
	WATER
}

export(TYPE) var type

onready var inventory = get_tree().get_nodes_in_group("inventory")[0]
onready var player = get_tree().get_nodes_in_group("player")[0]

func _on_PickupCoin_body_entered(body):
	if body.name == "Player":
		match type:
			TYPE.COIN:
				var chance = randf()
				
				if chance <= 0.6:
					inventory.money += 1
				elif chance <= 0.9:
					inventory.money += 2
				else:
					inventory.money += 3
			TYPE.BANDAGE:
				player.health += 25
			TYPE.WATER:
				inventory.gain_item(6) # Inventory.ITEM.WATER causes cyclic references. god damnit GDScript
		
		GlobalAudio.play("affirmative")
		queue_free()
