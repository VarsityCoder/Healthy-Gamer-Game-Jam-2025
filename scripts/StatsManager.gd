extends Node

signal stat_changed(stat_name: String, new_value: float)
signal player_status_changed(statuses: Array[String])
signal time_updated(game_time: float)

var stats = {
	"energy": 100,
	"burnout": 0,
	"cognition": 100,
	"body": 100
}

var statuses: Array[String] = []   # ["Hungry", "Grungy"]
var game_time: float = 0
var time_multiplier: float = 1.0

func _process(delta: float) -> void:
	game_time += delta * time_multiplier
	emit_signal("time_updated", game_time)
	
func initStats():
	emit_signal("stat_changed", "cognition", stats["cognition"])
	emit_signal("stat_changed", "body", stats["body"])
	emit_signal("stat_changed", "energy", stats["energy"])
	emit_signal("stat_changed", "burnout", stats["burnout"])

func get_stat(statName: String) -> float:
	return stats.get(statName, 0)

func set_stat(statName: String, value: float) -> void:
	if not stats.has(statName): return
	stats[statName] = clamp(value, 0, 100)
	emit_signal("stat_changed", statName, stats[statName])

func add_status(status: String) -> void:
	if not statuses.has(status):
		statuses.append(status)
	emit_signal("player_status_changed", statuses)

func remove_status(status: String) -> void:
	statuses.erase(status)
	emit_signal("player_status_changed", statuses)
