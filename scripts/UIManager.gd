extends Control

@onready var action_container = $MarginContainer/MarginContainer/ActionContainer
@onready var body_bar = $MarginContainer/MarginContainer/StatBars/BodyBar
@onready var energy_bar = $MarginContainer/MarginContainer/StatBars/EnergyBar
@onready var burnout_bar = $MarginContainer/MarginContainer/StatBars/BurnoutBar
@onready var cognition_bar = $MarginContainer/MarginContainer/StatBars/CognitionBar
@onready var timer_text = $MarginContainer/MarginContainer/StatBars/TimeLeft
@onready var statuses_text = $MarginContainer/MarginContainer/StatBars/PlayerStatuses
@onready var overlay = $MarginContainer/CutsceneOverlay
@onready var clock = $MarginContainer/MarginContainer/DateTime

@export var music : Array[AudioStream]
@export var drums : Array[AudioStream]
@export var sfx : Dictionary[String, AudioStream]

var current_melody = randi_range(0, music.size()-1)
var current_drums = randi_range(0, drums.size()-1)

func _ready() -> void:
	# Connect stats to UI bars
	StatsManager.stats_changed.connect(_on_stats_changed)
	StatsManager.player_status_changed.connect(_on_player_status_changed)
	TimeManager.time_updated.connect(_on_time_updated)
	TimeManager.day_updated.connect(_on_day_updated)
	CutsceneManager.activity_started.connect(_on_activity_started)
	CutsceneManager.activity_finished.connect(_on_activity_finished)
	StatsManager.initStats()
	hide_cutscene_overlay()
	
	change_music()

func _on_player_status_changed(statuses):
	var temp = "Status: "
	if statuses:
		for i in len(statuses)-1:
			temp += statuses[i] + ", "
		temp += statuses[-1]
	statuses_text.text = temp

func _on_stats_changed(stats) -> void:
	energy_bar.value = stats["energy"]
	burnout_bar.value = stats["burnout"]
	cognition_bar.value = stats["cognition"]
	body_bar.value = stats["body"]

func _on_time_updated(_game_time: float):
	clock.text = "Day: " + str(TimeManager.current_day) + " Time: " + str(TimeManager.clock_time_formatted)
	timer_text.text = "Time: " + str(snapped(TimeManager.clock_time, 0.01)) + ", " + str(TimeManager.days_left) + " Days, " + str(int(TimeManager.hours_left)) + " Hours, " + str(int(TimeManager.mins_left)) + " mins remaining..."

func change_music():
	if music.size() > 0:
		SoundManager.stop_sound(music[current_melody])
		SoundManager.stop_sound(drums[current_drums])
		current_melody = randi_range(0, music.size()-1)
		current_drums = randi_range(0, drums.size()-1)
		print("MUSIC: Current track: #",current_melody," - ", music[current_melody].resource_path.get_file().get_basename())
		print("MUSIC: Current drum track: #",current_drums," - ", drums[current_drums].resource_path.get_file().get_basename())
		SoundManager.play_sound(music[current_melody])
		SoundManager.play_sound(drums[current_drums])
	else:
		print("Music has:", music)
		
func _on_day_updated(current_day):
	if current_day > 1:
		change_music()

func _on_activity_started(command: Command) -> void:
	print("Started:", command.activity_name)
	# ADD FUNCTIONALITY FOR ANIMATIONS
	if command.activity_name in sfx:
		SoundManager.play_sound(sfx[command.activity_name])
		
	show_cutscene_overlay()

func _on_activity_finished(command: Command) -> void:
	print("Ended:", command.activity_name)
	# HIDE ANIMATIONS
	if command.activity_name in sfx:
		SoundManager.stop_sound(sfx[command.activity_name])
	_clear_actions()
	hide_cutscene_overlay()

func show_cutscene_overlay():
	overlay.visible = true
	overlay.modulate.a = 0.0
	overlay.create_tween().tween_property(overlay, "modulate:a", 1.0, 0.5)

func hide_cutscene_overlay():
	overlay.create_tween().tween_property(overlay, "modulate:a", 0.0, 0.5).finished.connect(
		func(): overlay.visible = false
	)

func show_actions(commands: Array[Command]) -> void:
	_clear_actions()
	
	var action_list = commands
	
	if "Overloaded" in StatsManager.statuses:
		action_list.shuffle()
	
	for command in action_list:
		var btn_scene = preload("res://assets/components/ActivityButton.tscn")
		var btn = btn_scene.instantiate()
		btn.command = command
		
		if not command.is_available():
			print(command.activity_name," is not available!")
			btn.disabled = true
			
		#btn.player_path = player.get_path()
		btn.text = command.activity_name
		action_container.add_child(btn)

func _clear_actions():
	for child in action_container.get_children():
		child.queue_free()
