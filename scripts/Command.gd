extends Resource
class_name Command

@export var activity_name: String = "Unnamed"
@export var duration_hours: float = 0.0
@export var effects: Dictionary = {}   # e.g. {"energy": -20, "burnout": +5}
@export var statuses_added: Array[String] = []
@export var statuses_removed: Array[String] = []
@export var cooldown_hours: float = 0.0
@export var special_rule: String = ""  # description for now

var last_used_time: float = -99999.0

func is_available(current_time: float) -> bool:
	# Check cooldown
	if cooldown_hours > 0 and current_time - last_used_time < cooldown_hours * Globals.seconds_per_day:
		return false
	
	# Example special rule enforcement
	if special_rule == "not after 7pm":
		var hour = int(floor(current_time / Globals.seconds_per_day) % 24)
		if hour >= 19:  # 7pm
			return false
	
	return true

func execute(player: Node) -> void:
	CutsceneManager.start_activity(self, player)
	last_used_time = StatsManager.game_time
