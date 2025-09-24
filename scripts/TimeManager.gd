extends Node

signal time_updated(game_time: float)

var game_time: float = 0
var time_multiplier: float = 1.0

var days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
var hours_left = (int(Globals.total_time - floor(game_time)) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
var mins_left = int(hours_left * 60) % 60

func _process(delta: float) -> void:
	game_time += delta * time_multiplier
	days_left = int((Globals.total_time - ceil(game_time)) / float(Globals.seconds_per_day))
	hours_left = (int(floor(Globals.total_time - floor(game_time))) % Globals.seconds_per_day) / (Globals.seconds_per_day / 24.0)
	mins_left = int(hours_left * 60) % 60
	emit_signal("time_updated", game_time)
