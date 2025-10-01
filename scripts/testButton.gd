extends Button

var mainScene = preload("res://assets/levels/apartmentStatsTest.tscn")

func _on_pressed() -> void:
	CutsceneManager.go_to_apt()
