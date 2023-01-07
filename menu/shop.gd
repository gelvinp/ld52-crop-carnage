extends PanelContainer

onready var corn_seed: Label = $MarginContainer/VBoxContainer/GridContainer/CornSeeds/Label
onready var pome_seed: Label = $MarginContainer/VBoxContainer/GridContainer/PomeSeeds/Label
onready var pump_seed: Label = $MarginContainer/VBoxContainer/GridContainer/PumpSeeds/Label
onready var coin: Label = $MarginContainer/VBoxContainer/GridContainer/Coins/Label
onready var corn: Label = $MarginContainer/VBoxContainer/GridContainer/Corn/Label
onready var pome: Label = $MarginContainer/VBoxContainer/GridContainer/Pome/Label
onready var pump: Label = $MarginContainer/VBoxContainer/GridContainer/Pump/Label
onready var water: Label = $MarginContainer/VBoxContainer/GridContainer/Water/Label
onready var inventory: Inventory = get_tree().get_nodes_in_group("inventory")[0]


func _on_ExitShop_pressed():
	visible = false
	get_tree().paused = false


func _unhandled_input(event):
	if visible and (event.is_action_pressed("pause") or event.is_action_pressed("shop")):
		visible = false
		get_tree().paused = false
		get_tree().set_input_as_handled()


func _input(event):
	if not visible and event.is_action_pressed("shop"):
		update_labels()


func update_labels():
	corn_seed.text = str(inventory.quantity_of(Inventory.ITEM.CORN_SEED))
	pome_seed.text = str(inventory.quantity_of(Inventory.ITEM.POME_SEED))
	pump_seed.text = str(inventory.quantity_of(Inventory.ITEM.PUMP_SEED))
	corn.text = str(inventory.quantity_of(Inventory.ITEM.CORN))
	pome.text = str(inventory.quantity_of(Inventory.ITEM.POME))
	pump.text = str(inventory.quantity_of(Inventory.ITEM.PUMP))
	water.text = str(inventory.quantity_of(Inventory.ITEM.WATER))


func _attempt_purchase(of_item, for_cost):
	print("Cost: ", for_cost)
	inventory.gain_item(of_item)
	update_labels()
