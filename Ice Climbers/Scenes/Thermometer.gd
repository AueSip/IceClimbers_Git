extends Node

onready var max_heat = PlayerStats.max_heat
onready var tempProgress = $TextureProgress
func _ready():
	tempProgress.max_value = max_heat
	
func _process(delta):
	if tempProgress.value != PlayerStats.heat:
		tempProgress.value = PlayerStats.heat
	if tempProgress.value <=0:
		get_tree().quit()
