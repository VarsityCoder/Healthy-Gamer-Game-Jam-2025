extends Node

@onready var player = get_tree().get_root().get_node("Apartment/Player")
@onready var ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")

func perform(command: Command) -> void:
	command.execute()

func availableActions(actions):
	ui_manager.show_actions(actions)
	
func clearActions():
	ui_manager._clear_actions()
