extends Control

# Creamos la señal
signal closed

func _on_button_pressed() -> void:
	# Emitimos la señal para que el menú de pausa sepa que nos cerramos
	closed.emit()
	
	# Si venimos del menú principal (escena completa), cambiamos de escena
	if get_tree().current_scene.scene_file_path == "res://Scenes/UI/como_jugar.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")
