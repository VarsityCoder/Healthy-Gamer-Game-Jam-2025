extends CharacterBody2D

@export var SPEED = 100.0
var input_lock = false

func _ready():
	CutsceneManager.activity_started.connect(_on_activity_start)
	CutsceneManager.activity_finished.connect(_on_activity_end)
	
func _on_activity_start(command):
	input_lock = true
	
func _on_activity_end(command):
	input_lock = false

func _process(delta: float) -> void:
	var move_vector : Vector2 = Input.get_vector("left", "right","up", "down")
	
	if !input_lock:
		velocity = move_vector * SPEED


	if velocity.x > 0:
		$AnimatedSprite2D.play("walk_left")
		$AnimatedSprite2D.flip_h = true
		
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk_left")
		$AnimatedSprite2D.flip_h = false

	elif velocity.y > 0:
		$AnimatedSprite2D.play("walk_left")
		
	elif velocity.y < 0:
		$AnimatedSprite2D.play("walk_left")

	else:
		#$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("idle")
	
	
	move_and_slide()
