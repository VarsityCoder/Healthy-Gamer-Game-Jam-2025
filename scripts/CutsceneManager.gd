extends Node

signal activity_started(command: Command)
signal activity_finished(command: Command)

@onready var ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")

var is_running: bool = false
	
func start_activity(command: Command) -> void:
	if is_running: return
	is_running = true
	
	emit_signal("activity_started", command)
	ui_manager.show_cutscene_overlay()
	
	# INSERT CUTSCENES HERE
	# INSERT MINIGAMES HERE
	
	# Advancing game time
	var game_seconds = command.duration_hours * Globals.game_hour
	if command.activity_name == "Sleep":
		TimeManager.game_time += game_seconds
	else:
		TimeManager.game_time += game_seconds * TimeManager.time_multiplier
	
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
		var energy_val = 100 - floor(StatsManager.get_stat("burnout") / 2)
		StatsManager.set_stat("energy", max(0, energy_val))
		
	# Special case for Apply for Jobs
	if command.activity_name == "Apply to Jobs":
		WinStateManager.check_job_stats()
		
	# if we update our cv enough we will have a better chance at the job
	if command.activity_name == "Update CV":
		WinStateManager.cv_updates += 1
		print("Total CV updates is now ", WinStateManager.cv_updates)
	if command.activity_name == "Practice For Interviews":
		WinStateManager.practice_interviews += 1
		print("Total Practice Interviews is now ", WinStateManager.practice_interviews)
	
	# Special case for emails
	if command.activity_name == "Check Email":
		#if TimeManager.clock_time > 9.0:
			# DIALOGUE BOX
		print("EMAILS: ", WinStateManager.emails)
		for i in WinStateManager.emails:
			print(i)
	
	var sound_length = 2
	if command.activity_name in ui_manager.sfx:
		sound_length = ui_manager.sfx[command.activity_name].get_length()
	sound_length = 6 if sound_length > 6 or not sound_length else sound_length
	
	await get_tree().create_timer(sound_length).timeout  # fake transition
	print(command.activity_name, " sound effect took ", sound_length)
	
	for p in command.prereqs:
		ActivityManager.prereqs.erase(p)
	ActivityManager.prereqs[command.activity_name] = 1
	
	ui_manager.hide_cutscene_overlay()
	emit_signal("activity_finished", command)
	is_running = false
