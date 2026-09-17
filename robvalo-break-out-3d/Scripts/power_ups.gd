extends Control

# Timbre para avisar al menú de pausa que nos cerramos
signal closed

func _on_button_pressed() -> void:
	# 1. Avisar al menú de pausa si está escuchando
	closed.emit()
	
	# 2. Si venimos directamente desde el Menú Principal, cambiamos de escena
	if get_tree().current_scene.scene_file_path == "res://Scenes/UI/power_ups.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")
