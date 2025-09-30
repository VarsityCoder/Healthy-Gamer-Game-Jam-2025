extends Node

signal time_updated(game_time: float)
signal day_updated(days_left: int)

var game_time: float = 0
var time_multiplier: float = 1.0

var days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
var hours_left = (int(Globals.total_time - floor(game_time)) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
var mins_left = int(hours_left * 60) % 60

var current_day = int(float(Globals.total_time) / Globals.seconds_per_day) - days_left
var clock_time = 24 - hours_left
var clock_time_mins = 60 - mins_left
var clock_time_formatted = "%2d:%02d" % [clock_time, clock_time_mins]

func _process(delta: float) -> void:
	var prev_day = current_day
	game_time += delta * time_multiplier
	days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
	hours_left = (int(floor(Globals.total_time - floor(game_time))) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
	mins_left = int(hours_left * 60) % 60
	
	current_day = int(float(Globals.total_time) / Globals.seconds_per_day) - days_left
	clock_time = 24.0 - hours_left
	clock_time_mins = 60 - mins_left
	
	var temp_hours = int(clock_time) % 12 if int(clock_time) % 12 != 0 else 12
	clock_time_formatted = "%2d:%02d" % [int(temp_hours), int(clock_time_mins) % 60]
	if clock_time > 12:
		clock_time_formatted += " PM"
	else:
		clock_time_formatted += " AM"
		
	emit_signal("time_updated", game_time)
	
	#if int(clock_time * 100) % 100 == 0 and current_day != prev_day:
	if current_day != prev_day:
		#print(clock_time)
		emit_signal("day_updated", current_day)
		print("Day changed to ", current_day)
	
	# REMOVE LATER FOR TESTING
	if Input.is_action_pressed("testTimeUp"):
		set_time_dialation(5.0)
		
	if Input.is_action_pressed("testTimeDown"):
		reset_time_dialation()

func set_time_dialation(new_multiplier):
	time_multiplier = new_multiplier
	print("Time is now going ",new_multiplier,"x speed...")
	
func reset_time_dialation():
	time_multiplier = 1.0
	print("Time dialation reset.")

# REMOVE LATER FOR TESTING
