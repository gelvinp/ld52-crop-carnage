extends Node

const sources = {
	"affirmative": preload("res://sounds/affirmative.wav"),
	"negative": preload("res://sounds/negative.wav"),
	"enemy_death": preload("res://sounds/enemy_death.wav"),
	"explosion": preload("res://sounds/explosion.wav")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
	for key in sources.keys():
		var stream = sources[key]
		var players = []
		
		var node = Node.new()
		node.name = key
		add_child(node)
		
		for i in range(ProjectSettings.get_setting("global/polyphony") as int):
			var player = AudioStreamPlayer.new()
			player.stream = stream
			node.add_child(player)
			players.append(player)
		
		sources[key] = players


func play(stream):
	for player in sources[stream]:
		if not player.playing:
			player.play()
			return
	
	push_warning("Ran out of audio channels to play " + stream + ". Consider increasing polyphony (currently: " + str(ProjectSettings.get_setting("global/polyphony")) + ")")
