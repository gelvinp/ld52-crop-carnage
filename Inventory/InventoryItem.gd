extends Control

const HALF_TRANSPARENT = Color(1, 1, 1, 0.5)

var item = Inventory.ITEM.NOTHING setget set_item, get_item
var quantity = 0 setget set_quantity, get_quantity
var selected = false setget set_selected, get_selected

onready var base_tr: TextureRect = $Base
onready var item_tr: TextureRect = $Item
onready var item_tex: AnimatedTexture = $Item.texture
onready var quantity_label: Label = $Quantity


func _ready():
	item_tex.current_frame = Inventory.ITEM.NOTHING
	quantity_label.text = ""
	base_tr.modulate = HALF_TRANSPARENT


func set_item(new_item):
	item = new_item
	item_tex.current_frame = new_item


func get_item():
	return item


func set_quantity(new_quantity):
	quantity = new_quantity
	quantity_label.text = str(new_quantity)
	if new_quantity == 0:
		base_tr.modulate = HALF_TRANSPARENT
		item_tr.modulate = HALF_TRANSPARENT
	else:
		item_tr.modulate = Color.white


func get_quantity():
	return quantity


func set_selected(new_selected):
	selected = new_selected
	base_tr.modulate = Color.white if new_selected else HALF_TRANSPARENT


func get_selected():
	return selected
