extends Node

signal time_updated(game_time: float)

var game_time: float = 0
var time_multiplier: float = 1.0

var days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
var hours_left = (int(Globals.total_time - floor(game_time)) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
var mins_left = int(hours_left * 60) % 60

var clock_time = 24 - hours_left
var clock_time_mins = 60 - mins_left
var clock_time_formatted = "%2d:%02d" % [clock_time, clock_time_mins]

func _process(delta: float) -> void:
	game_time += delta * time_multiplier
	days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
	hours_left = (int(floor(Globals.total_time - floor(game_time))) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
	mins_left = int(hours_left * 60) % 60
	clock_time = 24.0 - hours_left
	clock_time_mins = 60 - mins_left
	
	var temp_hours = int(clock_time) % 12 if int(clock_time) % 12 != 0 else 12
	clock_time_formatted = "%2d:%02d" % [int(temp_hours), int(clock_time_mins) % 60]
	if clock_time > 12:
		clock_time_formatted += " PM"
	else:
		clock_time_formatted += " AM"
		
	emit_signal("time_updated", game_time)
