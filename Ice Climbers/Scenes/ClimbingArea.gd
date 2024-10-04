extends Area2D

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$CollisionShape2D.disabled = true
		$Timer.start()
	if $Timer.is_stopped():
		$CollisionShape2D.disabled = false
		
func _on_Climbable_body_entered(body):
	 if body.is_in_group("climber"):
			body.climbing = true


func _on_Climbable_body_exited(body):
	if body.is_in_group("climber"):
			body.climbing = false
