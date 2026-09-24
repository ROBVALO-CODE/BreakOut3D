extends Control

signal closed

func _on_button_pressed() -> void:
	# 1. Emitimos la señal por si está instanciada sobre la pausa
	closed.emit()
	
	# 2. Verificamos si esta escena es la escena RAÍZ actual del juego
	# Si 'current_scene' es este mismo nodo, significa que se cargó con change_scene_to_file
	if get_parent() == get_tree().root:
		get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")
	else:
		pass
