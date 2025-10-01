extends Node2D

#func _input(event):
	#if event is InputEventMouseMotion or event is InputEventMouseButton:
		#var pos = get_viewport().get_mouse_position()
		#var hovered = get_viewport().gui_get_hovered_control()
		#if hovered:
			#print("Mouse over:", hovered.name, " (mouse_filter:", hovered.mouse_filter, ")")
		#else:
			#print("Mouse over: nothing")
