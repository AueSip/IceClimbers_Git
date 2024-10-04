extends Node2D


var tempTimer = PlayerStats.get_node("TempTimer")



func _on_Area2D_body_entered(body):
	tempTimer.stop()


func _on_Area2D_body_exited(body):
	tempTimer.start()


