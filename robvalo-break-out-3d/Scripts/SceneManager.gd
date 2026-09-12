extends Node

# Cambia de escena de forma segura limpiando la pausa previa
func change_scene(target_scene_path: String) -> void:
	get_tree().paused = false # Asegura que el juego no arranque congelado
	get_tree().change_scene_to_file(target_scene_path)
