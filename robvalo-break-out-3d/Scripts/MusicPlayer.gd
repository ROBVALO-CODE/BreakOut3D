extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(player)
	player.bus = "Music"

func play_track(stream: AudioStream, volume_db: float = 0.0) -> void:
	if player.stream == stream and player.playing:
		return # ya está sonando, evita reiniciar al recargar la escena
	player.stream = stream
	player.volume_db = volume_db
	player.play()

func stop() -> void:
	player.stop()
