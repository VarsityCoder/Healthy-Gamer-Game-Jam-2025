extends Node

signal stats_changed(stats)
signal player_status_changed(statuses: Array[String])

var low_pass = AudioServer.get_bus_effect(1,0)

var stat_timer = null

var stats = {
	"energy": 100,
	"burnout": 0,
	"cognition": 100,
	"body": 100
}

var statuses: Array[String] = []   # ["Hungry", "Grungy"]

func _ready() -> void:
	#var stat_timer = get_tree().get_root().get_node("Apartment/StatTimer")
	stat_timer = get_tree().get_root().get_node("Apartment/StatTimer")

func initStats():
	emit_signal("stats_changed", stats)
	low_pass.cutoff_hz = 20500
	stat_timer = get_tree().get_root().get_node("Apartment/StatTimer")
	if stat_timer:
		stat_timer.timeout.connect(_on_stat_timer_timeout)
		print("Reconnected Stats Timer")
	else:
		print("couldn't find node!")
	
func _on_stat_timer_timeout():
	# Check if any activities haven't been done in a while	
	var stat_change = false
	var times_since_actions = ActivityManager.time_since_all()
	#print(times_since_actions)
	if times_since_actions.has("Eat") and times_since_actions["Eat"] > 8.0 * Globals.game_hour:
		add_status("Hungry")
		
	if times_since_actions.has("Shower") and times_since_actions["Shower"] > 18.0 * Globals.game_hour:
		add_status("Grungy")
		
	if times_since_actions.has("Yoga") and times_since_actions["Yoga"] > 20.0 * Globals.game_hour:
		add_status("Achey")
		
	if times_since_actions.has("Take A Walk") and times_since_actions["Take A Walk"] > 20.0 * Globals.game_hour:
		add_status("Achey")
		
	if "Achey" in statuses:
		print("Feeling Achey, lowering stats...")
		stats["burnout"] = stats["burnout"] + 1 * TimeManager.time_multiplier
		stats["body"] = stats["body"] - 1 * TimeManager.time_multiplier
		stat_change = true
		
	if "Grungy" in statuses:
		print("Feeling Grungy, lowering stats...")
		stats["body"] = clamp(stats["body"], 0, 60)
		stats["burnout"] = stats["burnout"] + 1 * TimeManager.time_multiplier
		stat_change = true
		
	if "Overloaded" in statuses:
		print("Feeling Overloaded, lowering stats...")
		# stats["energy"] = stats["energy"] - 1 * TimeManager.time_multiplier
		stats["burnout"] = stats["burnout"] + 1 * TimeManager.time_multiplier
		stats["cognition"] = clamp(stats["cognition"], 0, 40)
		stat_change = true
		
	if "Hungry" in statuses:
		print("Feeling Hungry, lowering stats...")
		stats["burnout"] = stats["burnout"] + 2 * TimeManager.time_multiplier
		stats["cognition"] = stats["cognition"] - 2 * TimeManager.time_multiplier
		stat_change = true
		
	if stat_change:
		emit_signal("stats_changed", stats)
		
func get_stat(statName: String) -> float:
	return stats.get(statName, 0)

func set_stat(statName: String, value: float) -> void:
	if not stats.has(statName): return
	stats[statName] = clamp(value, 0, 100)
	#low_pass.cutoff_hz = value*100
	
	# Special Conditions
	if stats["cognition"] < 25:
		add_status("Overloaded")
		
	# Hyperfocus Conditions
	if stats["cognition"] > 50 and stats["body"] > 70:
		if "Hyperfocus" not in statuses:
			add_status("Hyperfocus")
	else:
		if "Hyperfocus" in statuses:
			remove_status("Hyperfocus")
		
	emit_signal("stats_changed", stats)

func add_status(status: String) -> void:
	if not statuses.has(status):
		statuses.append(status)
		print("Status added: ", status)
		
		# Special Add Conditions
		if status == "Hungry":
			stats["burnout"] = stats["burnout"] + 20
			
		if status == "Hyperfocus":
			TimeManager.set_time_dialation(0.5)
			
	emit_signal("player_status_changed", statuses)

func remove_status(status: String) -> void:
	statuses.erase(status)
	print("Status removed: ", status)
	
	# Special Remove Conditions
	if status == "Hungry":
		stats["burnout"] = stats["burnout"] - 20
	if status == "Hyperfocus":
			TimeManager.reset_time_dialation()
		
	emit_signal("player_status_changed", statuses)
