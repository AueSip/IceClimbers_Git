extends Node2D

onready var heatTimer = $HeatRefresh

var temptimer = PlayerStats.get_node("TempTimer")



func _on_HeatArea_body_entered(body):
	print("entered")
	heatTimer.start()
	temptimer.stop()
func _on_HeatArea_body_exited(body):
	heatTimer.stop()
	temptimer.start()

func _on_HeatRefresh_timeout():
	PlayerStats.heat +=20
