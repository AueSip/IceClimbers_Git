extends Node

	
export(int) var max_heat = 1 setget set_max_heat
var heat = max_heat setget  set_heat

signal no_heat
signal heat_changed(value)
signal max_heat_changed(value)


func set_max_heat(value):
	max_heat = value
	self.heat = min(heat, max_heat)
	emit_signal("max_heat_changed", max_heat)
	
	
func set_heat(value):
	heat = value
	emit_signal("heat_changed", heat)
	if heat <= 0:
		emit_signal("no_heat")
func _ready():
	self.heat = max_heat

func _on_TempTimer_timeout():
	heat -=10
	
