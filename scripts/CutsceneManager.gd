extends Node

signal activity_started(command: Command)
signal activity_finished(command: Command)

var current_command = null

const scenes = {
	"Apartment": preload("res://assets/levels/apartmentStatsTest.tscn"),
	#d"Update CV": preload("res://assets/levels/drag_example.tscn"),
	"Check Email": preload("res://assets/levels/hgmail.tscn"),
}

var interview_scenes = [
	preload("res://assets/levels/interview1.tscn"),
	null,
]

var game_over_scene = preload("res://assets/levels/game_over.tscn")
var win_scene = preload("res://assets/levels/win.tscn")
var menu_scene = preload("res://assets/levels/menu.tscn")
var prologue_scene = preload("res://assets/levels/prologue.tscn")

@onready var ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")

var is_running: bool = false
	
func start_activity(command: Command) -> void:
	ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")
	#if is_running: return
	#is_running = true
	print("Starting activity...")
	emit_signal("activity_started", command)
	current_command = command
	ui_manager.show_cutscene_overlay()
	
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
		if WinStateManager.check_job_stats() == "failed ATS":
			WinStateManager.send_default_email()
		
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
		print("EMAILS: ", WinStateManager.get_emails())
		for i in WinStateManager.get_emails():
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
	
	# INSERT CUTSCENES HERE
	if command.activity_name in scenes:
		Globals.in_apartment = false
		go_to_scene(scenes[command.activity_name])
	else:
		if ui_manager:
			ui_manager.hide_cutscene_overlay()
		emit_signal("activity_finished", command)
		is_running = false
		Globals.in_apartment = true

func go_to_scene(scene):
	Globals.player_pos = get_tree().get_root().get_node("Apartment/Player").position
	print(Globals.player_pos)
	if scene != null:
		get_tree().change_scene_to_packed(scene)
		
func go_to_apt():
	get_tree().change_scene_to_packed(scenes["Apartment"])
	Globals.in_apartment = true
	if current_command:
		emit_signal("activity_finished", current_command)
		await get_tree().create_timer(0.3).timeout
		ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")
		ui_manager._clear_actions()
		get_tree().get_root().get_node("Apartment/Player").position = Globals.player_pos
		current_command = null
		
func start_interview():
	SoundManager.stop_all_sounds(0.5)
	var scene = interview_scenes[WinStateManager.current_interview]
	if scene != null:
		get_tree().change_scene_to_packed(scene)
		
func go_to_win_scene():
	SoundManager.stop_all_sounds(0.5)
	get_tree().change_scene_to_packed(win_scene)
	
func go_to_game_over_scene():
	SoundManager.stop_all_sounds(0.0)
	get_tree().change_scene_to_packed(game_over_scene)
	
func go_to_menu():
	SoundManager.stop_all_sounds(0.5)
	get_tree().change_scene_to_packed(menu_scene)

func start_new_game():
	SoundManager.stop_all_sounds(0.5)
	get_tree().change_scene_to_packed(prologue_scene)
