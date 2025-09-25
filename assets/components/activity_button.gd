extends Button

@export var command: Command

@onready var cooldownBar = $Cooldown

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _process(_delta: float) -> void:
	if not command.is_available():
		cooldownBar.visible = true
		print(command.activity_name, " should be ", 100.0 - int((TimeManager.game_time - command.last_used_time) / command.cooldown_hours))
		cooldownBar.value = 100.0 - int((TimeManager.game_time - command.last_used_time) / command.cooldown_hours)
	else:
		cooldownBar.visible = false

func _on_pressed() -> void:
	if ActivityManager and command:
		ActivityManager.perform(command)
