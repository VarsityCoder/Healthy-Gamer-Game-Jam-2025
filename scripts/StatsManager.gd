extends Node

signal stat_changed(stat_name: String, new_value: float)
signal player_status_changed(statuses: Array[String])

@onready var stat_timer = get_tree().get_root().get_node("Apartment/StatTimer")

var stats = {
	"energy": 100,
	"burnout": 0,
	"cognition": 100,
	"body": 100
}

var statuses: Array[String] = []   # ["Hungry", "Grungy"]

func _ready() -> void:
	stat_timer.timeout.connect(_on_stat_timer_timeout)
	
func initStats():
	emit_signal("stat_changed", "cognition", stats["cognition"])
	emit_signal("stat_changed", "body", stats["body"])
	emit_signal("stat_changed", "energy", stats["energy"])
	emit_signal("stat_changed", "burnout", stats["burnout"])
	
func _on_stat_timer_timeout():
	# Check if any activities haven't been done in a while		
	var times_since_actions = ActivityManager.time_since_all()
	print(times_since_actions)
	if times_since_actions.has("Eat") and times_since_actions["Eat"] > 8.0 * Globals.game_hour:
		add_status("Hungry")
		
	if times_since_actions.has("Shower") and times_since_actions["Shower"] > 18.0 * Globals.game_hour:
		add_status("Grungy")
		
	if times_since_actions.has("Yoga") and times_since_actions["Yoga"] > 20.0 * Globals.game_hour:
		add_status("Achey")
		
	if times_since_actions.has("Take A Walk") and times_since_actions["Take A Walk"] > 20.0 * Globals.game_hour:
		add_status("Achey")
		
func get_stat(statName: String) -> float:
	return stats.get(statName, 0)

func set_stat(statName: String, value: float) -> void:
	if not stats.has(statName): return
	stats[statName] = clamp(value, 0, 100)
	
	# Special Conditions
	if stats["cognition"] < 25:
		add_status("Overloaded")
		
	emit_signal("stat_changed", statName, stats[statName])

func add_status(status: String) -> void:
	if not statuses.has(status):
		statuses.append(status)
		
		# Special Add Conditions
		if status == "Hungry":
			stats["burnout"] += 20
			
	emit_signal("player_status_changed", statuses)

func remove_status(status: String) -> void:
	statuses.erase(status)
	
	# Special Remove Conditions
	if status == "Hungry":
		stats["burnout"] -= 20
		
	emit_signal("player_status_changed", statuses)
