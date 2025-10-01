extends Node2D

func _on_button_pressed() -> void:
	Globals.reset_game()
	CutsceneManager.start_new_game()
