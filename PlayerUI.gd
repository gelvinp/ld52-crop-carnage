extends VBoxContainer

onready var weapon: Label = $HBoxContainer/Weapon
onready var silly_text: Label = $SillyText
onready var timer: Timer = $SillyTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("equip", weapon, "set_text")
	EventBus.connect("silly", self, "_silly")


func _silly(text):
	silly_text.text = text
	timer.start()


func _on_SillyTimer_timeout():
	silly_text.text = ""
