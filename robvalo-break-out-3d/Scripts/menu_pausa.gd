extends Control

var como_jugar_scene = preload("res://Scenes/UI/como_jugar.tscn")
var power_ups_scene = preload("res://Scenes/UI/power_ups.tscn")
var como_jugar_instancia = null
var power_ups_instancia = null
var ajustes_volumen_scene = preload("res://Scenes/UI/Volumen_settings.tscn")
var ajustes_volumen_instancia = null


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
	if ajustes_volumen_instancia == null:
		ajustes_volumen_instancia = ajustes_volumen_scene.instantiate()
		add_child(ajustes_volumen_instancia)
		ajustes_volumen_instancia.closed.connect(_cerrar_ajustes_volumen)
	else:
		ajustes_volumen_instancia.visible = true

func _on_howtoplay_pause_menu_button_pressed() -> void:
	if como_jugar_instancia == null:
		como_jugar_instancia = como_jugar_scene.instantiate()
		add_child(como_jugar_instancia)
		
		# Nos conectamos a la señal que emite la escena al cerrarse
		como_jugar_instancia.closed.connect(_cerrar_como_jugar)
	else:
		como_jugar_instancia.visible = true

# Función conectada a la señal pressed del botón POWER-UPS en pausa
func _on_power_ups_pause_menu_button_pressed() -> void:
	if power_ups_instancia == null:
		power_ups_instancia = power_ups_scene.instantiate()
		add_child(power_ups_instancia)
		
		# Conectamos la señal closed a nuestra función de cierre
		power_ups_instancia.closed.connect(_cerrar_power_ups)
	else:
		power_ups_instancia.visible = true

func _cerrar_power_ups() -> void:
	if power_ups_instancia:
		power_ups_instancia.queue_free()
		power_ups_instancia = null

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false

func _cerrar_como_jugar() -> void:
	if como_jugar_instancia:
		como_jugar_instancia.queue_free() # Elimina la ventana flotante
		como_jugar_instancia = null
		
func _cerrar_ajustes_volumen() -> void:
	if ajustes_volumen_instancia:
		ajustes_volumen_instancia.queue_free()
		ajustes_volumen_instancia = null
