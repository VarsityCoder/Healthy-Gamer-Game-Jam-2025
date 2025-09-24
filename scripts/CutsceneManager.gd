extends Node

signal activity_started(command: Command)
signal activity_finished(command: Command)

@onready var ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")

var is_running: bool = false
	
func start_activity(command: Command, player: Node) -> void:
	if is_running: return
	is_running = true
	
	emit_signal("activity_started", command)
	ui_manager.show_cutscene_overlay()
	
	# Advancing game time
	var game_seconds = command.duration_hours * 3600.0
	StatsManager.game_time += game_seconds * StatsManager.time_multiplier
	
	# Applying stat effects
	for stat_name in command.effects.keys():
		var new_val = StatsManager.get_stat(stat_name) + command.effects[stat_name]
		StatsManager.set_stat(stat_name, new_val)
	
	# Applying status
	for s in command.statuses_added:
		StatsManager.add_status(s)
	for s in command.statuses_removed:
		StatsManager.remove_status(s)
	
	# Special cases like sleep
	if command.activity_name == "Sleep":
		var energy_val = 100 - StatsManager.get_stat("burnout")
		StatsManager.set_stat("energy", max(0, energy_val))
	
	await get_tree().create_timer(1.5).timeout  # fake transition
	
	ui_manager.hide_cutscene_overlay()
	emit_signal("activity_finished", command)
	is_running = false
