extends "./abstract_audio_player_pool.gd"


func play(resource: AudioStream, override_bus: String = "") -> AudioStreamPlayer:
	var player = prepare(resource, override_bus)
	fade_volume(player, -80.0, player.volume_db, 0.5)
	player.call_deferred("play")
	return player


func stop(resource: AudioStream) -> void:
	for player in busy_players:
		if player.stream == resource:
			fade_volume(player, player.volume_db, -80, 0.5)
			player.call_deferred("stop")

func is_playing(resource: AudioStream) -> bool:
	if resource != null:
		return get_busy_player_with_resource(resource) != null
	else:
		return busy_players.size() > 0
		
func get_currently_playing() -> Array[AudioStream]:
	var tracks: Array[AudioStream] = []
	for player in busy_players:
		tracks.append(player.stream)
	return tracks

func stop_all(fade_out_duration: float = 0.0) -> void:
	if fade_out_duration <= 0.0:
			fade_out_duration = 0.01

	for player in busy_players:
		fade_volume(player, player.volume_db, -80, fade_out_duration)
