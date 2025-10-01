extends ColorRect

var event_email = ""

func _gui_input(event):
	if event_email != "" and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Starting ", event_email)
		if "Call" in event_email:
			if "Stability Bank" in event_email:
				WinStateManager.current_interview = 0
			if "Bleeding Bat" in event_email:
				WinStateManager.current_interview = 1
				
			WinStateManager.read_email(event_email)
			CutsceneManager.start_interview()
		elif "Congratulations" in event_email:
			CutsceneManager.go_to_win_scene()
