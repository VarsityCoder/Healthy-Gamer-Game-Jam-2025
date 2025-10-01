extends Node2D

var is_dragging = false

var seconds_per_day = 900
var total_time = 12600
var total_days = int(float(total_time) / seconds_per_day)
var game_hour = int(floor(seconds_per_day / 24.0))
var in_apartment = true

var player_pos = null
