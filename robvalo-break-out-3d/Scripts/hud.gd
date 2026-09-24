extends Control

@export var lives: int = 3
# Define las vidas iniciales y las expone en el Inspector.
@onready var LivesLabel: Label = $Contenedor/LivesTextLabel/LivesLabel
@onready var ScoreLabel: Label = $Contenedor/ScoreLabel
@export var points: int = 0
@onready var FloatingText: Label = $Contenedor/ScoreLabel/FloatingText
var floating_tween: Tween

# Nodos obtenidos dinámicamente según la escena actual
var ball: Pelota
var menu_pausa: Node
var power_up_manager: Node

func _ready() -> void:
	# Obtener referencias dinámicas a la escena actual (funciona en Nivel, Nivel2, Nivel3, etc.)
	var current_scene = get_tree().current_scene
	if current_scene:
		ball = current_scene.get_node_or_null("Pelota") as Pelota
		menu_pausa = current_scene.get_node_or_null("Canvas_Layer/menu_pausa")
		power_up_manager = current_scene.get_node_or_null("PowerUpManager")

	# Corrige las vidas iniciales.
	if lives <= 0:
		lives = 3

	# El texto flotante inicia oculto.
	FloatingText.visible = false
	update_hud()

	if power_up_manager:
		# Descuenta una vida solamente cuando
		# PowerUpManager confirma que no quedan pelotas.
		if not power_up_manager.round_lost.is_connected(_on_round_lost):
			power_up_manager.round_lost.connect(_on_round_lost)

		# Suma puntos por los bloques destruidos
		# por cualquiera de las pelotas.
		if not power_up_manager.any_block_destroyed.is_connected(_on_block_destroyed):
			power_up_manager.any_block_destroyed.connect(_on_block_destroyed)
		
		# Recibe la señal cuando la raqueta
		# recoge un corazón.
		if not power_up_manager.extra_life_collected.is_connected(_on_extra_life_collected):
			power_up_manager.extra_life_collected.connect(_on_extra_life_collected)

func _on_round_lost() -> void:
	# PowerUpManager llama esta función solamente
	# cuando cayeron todas las pelotas.
	if lives <= 0:
		return

	lives -= 1
	update_hud()

	if lives <= 0:
		if is_instance_valid(ball):
			ball.state = Pelota.GameState.GameOver
			ball.linear_velocity = Vector3.ZERO
			ball.angular_velocity = Vector3.ZERO

		SceneManager.last_level_path = get_tree().current_scene.scene_file_path
		_go_to_game_over()

func _on_extra_life_collected() -> void:
	# Aumenta una vida y actualiza el texto.
	lives += 1
	update_hud()
	
func _go_to_game_over() -> void:
	await get_tree().create_timer(0.1).timeout
	SceneManager.change_scene("res://Scenes/UI/Game_over.tscn")    
	
func _on_block_destroyed() -> void:
	points += 100
	update_hud()
	var floating_points = 100
	show_floating_points(floating_points)

func show_floating_points(amount: int) -> void:
	# Coloca el texto
	FloatingText.text = "+" + str(amount)

	# Posición inicial: X = 180, Y = 100
	FloatingText.position = Vector2(180, 100)

	# Lo muestra completamente visible
	FloatingText.visible = true
	FloatingText.modulate.a = 1.0

	# Crea una nueva animación
	floating_tween = create_tween()
	floating_tween.set_parallel(true)

	# Hace que el texto suba
	floating_tween.tween_property(
		FloatingText,
		"position",
		Vector2(180, 40),
		0.8
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Hace que desaparezca
	floating_tween.tween_property(
		FloatingText,
		"modulate:a",
		0.0,
		0.8
	).set_delay(0.2)

	await floating_tween.finished

	FloatingText.visible = false

func update_hud() -> void:
	if LivesLabel:
		LivesLabel.text = "x " + str(lives)
	if ScoreLabel:
		# Actualiza el marcador con el puntaje en formato de cuatro dígitos
		ScoreLabel.text = "SCORE: " + "%04d" % points

func _on_menu_pause_button_pressed() -> void:
	if menu_pausa and menu_pausa.has_method("toggle_pause"):
		menu_pausa.toggle_pause()
