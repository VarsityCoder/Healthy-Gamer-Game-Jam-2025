extends Area2D
signal update_score
@onready var timer: Timer = $"../../Timer"
@export var bonk_height := 50
@export var ease_value := .5
@onready var collision_shape_2d: CollisionShape2D = $HitArea

var random_int : int
var ableToBeHit : bool = false
var mouse_in : bool = false
var initial_position : Vector2
var starting_position: Vector2

func _ready() -> void:
	starting_position = position
	initial_position = Vector2(position.x, position.y - 11)
	initial_position = global_position
	connect("update_score", Callable(get_parent(), "score_update"))
	

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and (mouse_in == true and ableToBeHit == true):
		move_down()
		emit_signal("update_score")


func _on_timer_timeout() -> void:
	print("Less than five hit")
	random_int = randi() % 11
	if random_int > 5 and ableToBeHit == false:
		ableToBeHit = true
		move_up()
	elif random_int <= 5 and ableToBeHit == true:
		print("Greater than five hit")
		ableToBeHit = false
		move_down()

func move_up():
	collision_shape_2d.disabled = false
	var tween = get_tree().create_tween()
	tween.tween_property($"..", "position", initial_position, 1.0)	
	timer.start()

func move_down():
	var tween = get_tree().create_tween()
	collision_shape_2d.disabled = true
	tween.tween_property($"..", "position", starting_position, 1.0)	
	timer.start()


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false  
