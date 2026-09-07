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
	if lives <= 0:
		lives = 3
	update_hud()
	
	FloatingText.visible = false
	
	if ball:
		var notifier = ball.get_node_or_null("VisibleOnScreenNotifier3D")
		if notifier and not notifier.screen_exited.is_connected(_on_ball_exited):
			notifier.screen_exited.connect(_on_ball_exited)
		
		# Conexión limpia y segura
		if not ball.block_destroyed.is_connected(_on_block_destroyed):
			ball.block_destroyed.connect(_on_block_destroyed)

func _on_ball_exited() -> void:
	#Cuando la pelota salga de la vista restar una vida a lives
	#y actualizar el hud
	lives -= 1
	update_hud()
	
	if lives <= 0:
		#Si las vidas de la pelota son iguales a 0 o menor cambia
		#el estado de pelota a GameOver haciendo que de acuerdo a
		#los parametros de pelota esta no siga su movimientoal salir
		#de la pantalla, de tal manera que la pelota no vuelve a su
		#posicion inicial dando a entender el fin de la partida por GameOver
		if ball:
			ball.state = Pelota.GameState.GameOver
			
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
		
