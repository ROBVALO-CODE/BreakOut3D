extends Control


func _ready() -> void:
	# Arranca música de fondo también aquí, para que el bus Music
	# se pueda probar desde la pantalla de Settings del menú principal
	MusicPlayer.play_track(preload("res://Audio/Audio_niveles/aundio_1.mp3"), -8.0)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/nivel.tscn")


func _on_how_to_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/como_jugar.tscn")


func _on_power_ups_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/power_ups.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Volumen_settings.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
