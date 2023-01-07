class_name Inventory
extends HBoxContainer

enum ITEM {
	CORN = 0,
	POME = 1,
	PUMP = 2,
	CORN_SEED = 3,
	POME_SEED = 4,
	PUMP_SEED = 5,
	WATER = 6,
	NOTHING = 7,
}

onready var items = [
	$Corn,
	$Pome,
	$Pump,
	$CornSeed,
	$PomeSeed,
	$PumpSeed,
	$Water
]

var selected_item = ITEM.NOTHING setget select_item, get_selected_item

onready var scroll_timer: Timer = $ScrollTimer


func _ready():
	# Demo shit
	gain_item(ITEM.CORN)
	gain_item(ITEM.WATER)
	select_item(ITEM.CORN)
	
	EventBus.connect("plant", self, "_on_planted")
	EventBus.connect("water", self, "spend_item", [ITEM.WATER])


func _unhandled_input(event):
	if event.is_action_pressed("item1"):
		select_item(ITEM.CORN)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item2"):
		select_item(ITEM.POME)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item3"):
		select_item(ITEM.PUMP)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item4"):
		select_item(ITEM.CORN_SEED)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item5"):
		select_item(ITEM.POME_SEED)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item6"):
		select_item(ITEM.PUMP_SEED)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item7"):
		select_item(ITEM.WATER)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item_next"):
		select_in_direction(1)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("item_prev"):
		select_in_direction(-1)
		get_tree().set_input_as_handled()


func gain_item(item, quantity = 1):
	items[item].quantity += quantity
	
	if items[item].item == ITEM.NOTHING:
		items[item].item = item


func spend_item(item, quantity = 1):
	items[item].quantity = max(0, items[item].quantity - quantity)
	
	if items[item].quantity == 0:
		select_item(ITEM.NOTHING)


func quantity_of(item):
	return items[item].quantity


func select_item(item):
	if selected_item != ITEM.NOTHING:
		items[selected_item].selected = false
	
	if item == ITEM.NOTHING or items[item].quantity > 0:
		selected_item = item
	
	if selected_item != ITEM.NOTHING:
		items[selected_item].selected = true


func get_selected_item():
	return selected_item


func _on_planted():
	spend_item(selected_item)


func select_in_direction(direction):
	if not scroll_timer.is_stopped():
		return
	
	var iterations = 0
	var next = selected_item
	
	while true:
		next += direction
		
		if next > ITEM.WATER:
			next -= ITEM.NOTHING
		elif next < ITEM.CORN:
			next += ITEM.NOTHING
		
		if iterations > 7:
			break
		
		iterations += 1
		
		if items[next].quantity > 0:
			select_item(next)
			scroll_timer.start()
			break
