extends ColorRect

var event_email = ""

func _gui_input(event):
	if event_email != "" and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Starting ", event_email)
		CutsceneManager.start_interview()
