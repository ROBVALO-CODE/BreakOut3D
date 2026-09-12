extends Control

func _input(event: InputEvent) -> void:
	#Esto de arriba es necesario porque se va a generar un evento input
	#en este caso, que yo oprima el esc, si no tuviera ese evento sino que oprimiera un boton
	#para acceder al menu de pausa, haria una funcion normal de button pressed
	#tal como las de el menu principal
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = visible
		
	#ahora si, hagamos las funciones de los botones
func _on_settings_pause_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_howtoplay_pause_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_power_ups_pause_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_home_button_pressed() -> void:
	pass # Replace with function body.

func _on_resume_button_pressed() -> void:
	pass # Replace with function body.
