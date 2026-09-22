class_name Pelota extends RigidBody3D

signal block_destroyed(block: Block)

# Informa cuál pelota salió del tablero.
signal ball_exited(ball: Pelota)

enum GameState {Idle, Playing, GameOver}
var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

# False para la original y true para la copia.
var es_copia: bool = false

# Evita reportar varias veces la misma caída.
var salida_reportada: bool = false

@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."

func _ready() -> void:
	# Aumentar la velocidad automáticamente si el archivo actual es nivel2.tscn
	if get_tree().current_scene.scene_file_path.ends_with("nivel2.tscn"):
		ballSpeed = 14.0 # Subimos la velocidad de 10.0 a 14.0 para el Nivel 2
		initvelocity = ballSpeed * Vector3.FORWARD

func _physics_process(delta: float) -> void:
	match state:
		GameState.Idle:
			if Input.is_action_just_pressed("ui_accept"):
				salida_reportada = false
				state = GameState.Playing
				linear_velocity = initvelocity
		GameState.Playing:
			moveDirection = linear_velocity.normalized()
			linear_velocity = ballSpeed * moveDirection
			angular_velocity = ballSpeed * Vector3.UP.cross(moveDirection)
		GameState.GameOver:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			
func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if state == GameState.Idle and not es_copia:
		position = initPosition
		position.x = raqueta.position.x

func _on_body_entered(body: Node) -> void:
	if not body is Block:
		return

	var block := body as Block

	# Evita golpear un bloque que ya se elimina.
	if block.is_queued_for_deletion():
		return

	var vida_restante: float = (
		block.recibir_dano(1.0)
	)

	# El bloque todavía tiene vida.
	if vida_restante > 0.0:
		return

	# Informa cuál bloque fue destruido.
	block_destroyed.emit(block)

	# Comprueba si era el último bloque.
	if bloques.get_child_count() <= 1:
		if get_tree().current_scene.scene_file_path.ends_with(
			"nivel2.tscn"
		):
			state = GameState.GameOver
		else:
			get_tree().change_scene_to_file(
				"res://Scenes/nivel2.tscn"
			)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# Solamente reporta pelotas que jugaban.
	if state != GameState.Playing:
		return

	# Evita emitir la señal varias veces.
	if salida_reportada:
		return

	salida_reportada = true

	nivel.disparar_explosion(
		global_position
	)

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# BallManager recibe esta pelota y revisa
	# si es original o duplicada.
	ball_exited.emit(self)
	
func prepare_for_new_round() -> void:
	# Solamente se reutiliza la original.
	es_copia = false
	salida_reportada = false
	visible = true

	position = initPosition
	position.x = raqueta.position.x

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	state = GameState.Idle
