extends Control

@export var lives: int = 3
#Define las vidas iniciales y las expone en el Inspector.
@onready var LivesLabel: Label = $LivesLabel
# Crea una referencia al nodo label en el HUD y 
#una al nodo Pelota dentro de la jerarquía del juego
@onready var ball: Pelota = get_node("/root/Nivel/Pelota")
@onready var ScoreLabel : Label = $ScoreLabel
@export var points: int = 0
@onready var FloatingText: Label = $ScoreLabel/FloatingText
var floating_tween: Tween

func _ready() -> void:
	#Si las vidas empiezan en 0 o menos actualiza el
	#HUD a 3 vidas
	if lives <= 0:
		lives = 3
	update_hud()
	
	# El texto flotante comienza oculto
	FloatingText.visible = false
	update_hud()
	
	if ball:
		#Conecta el notificador de la Pelota con screen_exited
		#para asegurarse de que avise cuando la pelota salga de
		#la vista de acuerdo a lo establecido en los parametros
		var notifier = ball.get_node("VisibleOnScreenNotifier3D")
		if notifier and not notifier.is_connected("screen_exited", Callable(self, "_on_ball_exited")):
			notifier.connect("screen_exited", Callable(self, "_on_ball_exited"))
		
		#Verifica si la señal ya está conectada para evitar conectarla dos veces por error.
		if not ball.is_connected("block_destroyed", Callable(self, "_on_block_destroyed")):
			ball.connect("block_destroyed", Callable(self, "_on_block_destroyed"))

func _on_ball_exited() -> void:
	lives -= 1
	update_hud()
	
	if lives <= 0:
		if ball:
			ball.state = Pelota.GameState.GameOver
		
		SceneManager.last_level_path = get_tree().current_scene.scene_file_path
		_go_to_game_over()
	
func _go_to_game_over() -> void:
	await get_tree().create_timer(0.1).timeout
	SceneManager.change_scene("res://Scenes/UI/Game_over.tscn")	
	
func _on_block_destroyed()-> void:
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
	if FloatingText:
		#Actualiza el marcador con el puntaje en formato de cuatro dígitos
		ScoreLabel.text = "SCORE: " + "%04d" % points
		
