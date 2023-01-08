extends VBoxContainer

onready var weapon: Label = $VBoxContainer/HBoxContainer/Weapon
onready var silly_text: Label = $SillyText
onready var timer: Timer = $SillyTimer
onready var money: Label = $VBoxContainer/HBoxContainer/HBoxContainer/Money
onready var health: TextureProgress = $VBoxContainer/HealthBar

export(Gradient) var health_colors


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("equip", weapon, "set_text")
	EventBus.connect("silly", self, "_silly")
	EventBus.connect("money", money, "set_text")
	EventBus.connect("health", self, "_on_health")


func _silly(text):
	silly_text.text = text
	timer.start()


func _on_SillyTimer_timeout():
	silly_text.text = ""


func _on_health(new_amt):
	health.value = new_amt
	health.tint_progress = health_colors.interpolate(float(new_amt) / 100.0)
