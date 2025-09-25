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

func is_available() -> bool:
	# Check cooldown
	if cooldown_hours > 0 and TimeManager.game_time - last_used_time < cooldown_hours * Globals.game_hour:
		return false
		
	#for key in effects:
		#if key != "burnout" and (StatsManager.stats[key] + effects[key]) <= 0:
			#return false
	
	if activity_name != "Binge Video Games" and activity_name != "Sleep" and (StatsManager.stats["energy"] + effects["energy"]) <= 0:
			return false
	
	# Example special rule enforcement
	if special_rule == "not after 7pm":
		var hour = TimeManager.clock_time
		if hour >= 19.0:
			return false
	
	return true

func execute() -> void:
	CutsceneManager.start_activity(self)
	last_used_time = TimeManager.game_time
