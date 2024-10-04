extends Node2D

export var windStrength = 100
export var windDirection = Vector2(0, -1)

func _on_Area2D_body_entered(body):
	body.inWindGust = true
	body.windStrength = windStrength
	body.windDirection = windDirection

func _on_Area2D_body_exited(body):
	body.inWindGust = false
	body.windStrength = 0
	body.windDirection = Vector2.ZERO


