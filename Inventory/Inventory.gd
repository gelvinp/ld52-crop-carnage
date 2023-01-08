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

const silly_corn = ["You Butter Be Sorry", "Aw Shucks!", "You're Corn-ered"]
const silly_pome = ["I'll Pome-el you!", "A Pome-machine Gun!", "Should've Worn Your Red Pants!"]
const silly_pump = ["En Gourd!", "I'll Hollow You Out!", "Get Squashed!"] # I really fucked myself over here, I can't top this

var selected_item = ITEM.NOTHING setget select_item, get_selected_item
var money := 0 setget set_money, get_money

onready var scroll_timer: Timer = $ScrollTimer


func _ready():
	# Demo shit
	gain_item(ITEM.CORN, 2)
	gain_item(ITEM.WATER)
	select_item(ITEM.CORN)
	
	EventBus.connect("plant", self, "_on_planted")
	EventBus.connect("water", self, "spend_item", [ITEM.WATER])
	EventBus.connect("harvest", self, "gain_item")


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
	elif event.is_action_pressed("equip"):
		ammunize()
		get_tree().set_input_as_handled()


func ammunize():
	match selected_item:
		ITEM.CORN:
			EventBus.emit_signal("ammunize", Weapon.TYPE.CORN, randi() % 2 + 2)
			EventBus.emit_signal("silly", silly_corn[randi() % silly_corn.size()])
		ITEM.POME:
			EventBus.emit_signal("ammunize", Weapon.TYPE.POME, randi() % 3 + 4)
			EventBus.emit_signal("silly", silly_pome[randi() % silly_pome.size()])
		ITEM.PUMP:
			EventBus.emit_signal("ammunize", Weapon.TYPE.PUMP, 2 if randf() >= 0.9 else 1)
			EventBus.emit_signal("silly", silly_pump[randi() % silly_pump.size()])
		_:
			return
	
	spend_item(selected_item)


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


func set_money(new_money):
	money = new_money
	EventBus.emit_signal("money", str(money))


func get_money():
	return money
