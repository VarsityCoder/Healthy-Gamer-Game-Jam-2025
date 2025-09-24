extends Button

@export var command: Command

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if ActivityManager and command:
		ActivityManager.perform(command)
