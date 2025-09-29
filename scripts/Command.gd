extends Resource
class_name Command

@export var activity_name: String = "Unnamed"
@export var duration_hours: float = 0.0
@export var effects: Dictionary = {}   # e.g. {"energy": -20, "burnout": +5}
@export var statuses_added: Array[String] = []
@export var statuses_removed: Array[String] = []
@export var cooldown_hours: float = 0.0
@export var special_rule: String = ""  # description for now
@export var prereqs: Array[String] = []

var last_used_time: float = -99999.0

var always_available = ["Binge Video Games", "Doom Scroll", "Sleep", "Eat Snack", "Drink Water"]

func is_available() -> bool:
	# we are only available if our activity's prereqs are met
	if prereqs.size() > 0:
		var any_prereqs = 0
		for p in prereqs:
			if p in ActivityManager.prereqs:
				any_prereqs = any_prereqs + 1
		# if none of the prereqs are there, return false
		if any_prereqs == 0:
			return false
	
	# Check cooldown
	if cooldown_hours > 0 and TimeManager.game_time - last_used_time < cooldown_hours * Globals.game_hour:
		return false
	
	if activity_name not in always_available and (StatsManager.stats["energy"] + effects["energy"]) <= 0:
		return false

	# if we found our prereq in the past activities and not ourselves we can do it
	# do dishes after you make a meal
	
	# if we update our cv enough we will have a better chance at the job
	
	# Example special rule enforcement
	if special_rule == "not after 7pm":
		var hour = TimeManager.clock_time
		if hour >= 19.0:
			return false
	if special_rule == "not after coffee":
		if "Drink Coffee" in ActivityManager.current_time_since_all:
			if ActivityManager.current_time_since_all["Drink Coffee"] < 6.0 * Globals.game_hour:
				return false
	
	return true

func execute() -> void:
	CutsceneManager.start_activity(self)
	last_used_time = TimeManager.game_time
