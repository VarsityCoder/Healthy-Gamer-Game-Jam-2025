extends Node2D

var is_dragging = false

var seconds_per_day = 900
var total_time = 900 * 14 #12600
var total_days = int(float(total_time) / seconds_per_day)
var game_hour = int(floor(seconds_per_day / 24.0))
var in_apartment = true

var player_pos = null

func reset_game():
	in_apartment = true
	player_pos = null
	WinStateManager.reset_game()
	StatsManager.reset_game()
	ActivityManager.reset_game()
	TimeManager.reset_game()
