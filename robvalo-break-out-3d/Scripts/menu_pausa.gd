extends Control

var como_jugar_scene = preload("res://Scenes/UI/como_jugar.tscn")
var como_jugar_instancia = null

func _input(event: InputEvent) -> void:
	#Esto de arriba es necesario porque se va a generar un evento input
	#en este caso, que yo oprima el esc, si no tuviera ese evento sino que oprimiera un boton
	#para acceder al menu de pausa, haria una funcion normal de button pressed
	#tal como las de el menu principal
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		
func toggle_pause() -> void:
	visible = !visible
	get_tree().paused = visible
		
	#ahora si, hagamos las funciones de los botones
func _on_settings_pause_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_howtoplay_pause_menu_button_pressed() -> void:
	if como_jugar_instancia == null:
		como_jugar_instancia = como_jugar_scene.instantiate()
		add_child(como_jugar_instancia)
		
		# Nos conectamos a la señal que emite la escena al cerrarse
		como_jugar_instancia.closed.connect(_cerrar_como_jugar)
	else:
		como_jugar_instancia.visible = true

func _on_power_ups_pause_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false

func _cerrar_como_jugar() -> void:
	if como_jugar_instancia:
		como_jugar_instancia.queue_free() # Elimina la ventana flotante
		como_jugar_instancia = null
