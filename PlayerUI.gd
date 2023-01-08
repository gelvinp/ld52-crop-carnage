extends VBoxContainer

onready var weapon: Label = $HBoxContainer/Weapon
onready var silly_text: Label = $SillyText
onready var timer: Timer = $SillyTimer
onready var money: Label = $HBoxContainer/HBoxContainer/Money


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("equip", weapon, "set_text")
	EventBus.connect("silly", self, "_silly")
	EventBus.connect("money", money, "set_text")


func _silly(text):
	silly_text.text = text
	timer.start()


func _on_SillyTimer_timeout():
	silly_text.text = ""
