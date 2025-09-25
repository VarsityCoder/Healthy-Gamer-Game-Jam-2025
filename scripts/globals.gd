extends Node2D

var is_dragging = false

var seconds_per_day = 900
var total_time = 12600
var game_hour = int(floor(seconds_per_day / 24.0))
