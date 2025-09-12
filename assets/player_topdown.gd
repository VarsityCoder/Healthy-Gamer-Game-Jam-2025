extends CharacterBody2D


@export var SPEED = 100.0


func _process(delta: float) -> void:
	var move_vector : Vector2 = Input.get_vector("left", "right","up", "down")
	
	velocity = move_vector * SPEED


	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_left")

	elif velocity.y > 0:
		$AnimatedSprite2D.play("move_down")
		
	elif velocity.y < 0:
		$AnimatedSprite2D.play("move_up")

	else:
		$AnimatedSprite2D.stop()
	
	
	move_and_slide()
