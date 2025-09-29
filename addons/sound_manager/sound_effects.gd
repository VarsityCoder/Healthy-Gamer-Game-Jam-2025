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
