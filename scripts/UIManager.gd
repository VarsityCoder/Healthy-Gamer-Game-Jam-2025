extends Control

@onready var action_container = $MarginContainer/MarginContainer/ActionContainer
@onready var body_bar = $MarginContainer/MarginContainer/StatBars/BodyBar
@onready var energy_bar = $MarginContainer/MarginContainer/StatBars/EnergyBar
@onready var burnout_bar = $MarginContainer/MarginContainer/StatBars/BurnoutBar
@onready var cognition_bar = $MarginContainer/MarginContainer/StatBars/CognitionBar
@onready var timer_text = $MarginContainer/MarginContainer/StatBars/TimeLeft
@onready var statuses_text = $MarginContainer/MarginContainer/StatBars/PlayerStatuses
@onready var overlay = $MarginContainer/CutsceneOverlay

func _ready() -> void:
	# Connect stats to UI bars
	StatsManager.stat_changed.connect(_on_stat_changed)
	StatsManager.player_status_changed.connect(_on_player_status_changed)
	TimeManager.time_updated.connect(_on_time_updated)
	CutsceneManager.activity_started.connect(_on_activity_started)
	CutsceneManager.activity_finished.connect(_on_activity_finished)
	StatsManager.initStats()
	hide_cutscene_overlay()

func _on_player_status_changed(statuses):
	var temp = "Status: "
	if statuses:
		for i in len(statuses)-1:
			temp += statuses[i] + ", "
		temp += statuses[-1]
	statuses_text.text = temp

func _on_stat_changed(stat_name: String, value: float) -> void:
	match stat_name:
		"energy":
			energy_bar.value = value
		"burnout":
			burnout_bar.value = value
		"cognition":
			cognition_bar.value = value
		"body":
			body_bar.value = value

func _on_time_updated(_game_time: float):
	timer_text.text = "Time: " + str(snapped(TimeManager.clock_time, 0.01)) + ", " + str(TimeManager.days_left) + " Days, " + str(int(TimeManager.hours_left)) + " Hours, " + str(int(TimeManager.mins_left)) + " mins remaining..."

func _on_activity_started(command: Command) -> void:
	print("Started:", command.activity_name)
	# ADD FUNCTIONALITY FOR ANIMATIONS
	show_cutscene_overlay()

func _on_activity_finished(command: Command) -> void:
	print("Ended:", command.activity_name)
	# HIDE ANIMATIONS
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
	for command in commands:
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
