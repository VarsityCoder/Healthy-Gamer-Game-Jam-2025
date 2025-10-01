extends "res://scripts/dialouge.gd"

func _finish_interview(outcome: String):
	
	CutsceneManager.go_to_menu()
