extends Node2D
@onready var points: Label = $"../Points"
var score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points.text = ("Score: 0")
	
func score_update():
	score += 1
	points.text = ("Score: " + str(score))
