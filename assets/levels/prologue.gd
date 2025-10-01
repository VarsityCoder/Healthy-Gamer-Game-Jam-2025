extends Node2D

var apartment = preload("res://assets/levels/apartmentStatsTest.tscn")

func _process(delta: float) -> void:
	if Input.is_action_pressed("enter"):
		CutsceneManager.go_to_apt()


func _on_video_stream_player_finished() -> void:
	CutsceneManager.go_to_apt()
