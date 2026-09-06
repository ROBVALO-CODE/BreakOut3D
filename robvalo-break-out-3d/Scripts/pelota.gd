class_name Pelota extends RigidBody3D


enum GameState {Idle, Playing, GameOver}

var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

# Cantidad de oportunidades
var oportunidades: int = 3

# Evita que una misma caída se registre varias veces
var perdiendo_vida: bool = false


@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."

@onready var particulas_impacto: GPUParticles3D = $particulas_impacto


func _physics_process(_delta: float) -> void:
	match state:

		GameState.Idle:
			if Input.is_action_just_pressed("ui_accept"):
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
	if state == GameState.Idle:
		position = initPosition
		position.x = raqueta.position.x


func _on_body_entered(body: Node) -> void:

	# ==========================================
	# LA PELOTA TOCA EL SUELO
	# ==========================================

	if body.name == "SueloMapa":

		if not perdiendo_vida:
			_perder_oportunidad()

		return


	# ==========================================
	# LA PELOTA TOCA UN BLOQUE
	# ==========================================

	if body is Block:

		if body.has_method("recibir_dano"):

			var block := body as Block
			var vida_restante: float = block.recibir_dano(1.0)

			if vida_restante <= 0.0 and bloques.get_child_count() == 1:
				state = GameState.GameOver


func _perder_oportunidad() -> void:

	perdiendo_vida = true

	# ==========================================
	# DETENER LA PELOTA
	# ==========================================

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO


	# ==========================================
	# CREAR UNA COPIA DE LAS PARTÍCULAS
	# ==========================================

	var explosion := particulas_impacto.duplicate() as GPUParticles3D

	var posicion_explosion := global_transform


	# Agregar las partículas al nivel
	get_tree().current_scene.add_child(explosion)


	# Colocarlas exactamente donde estaba la pelota
	explosion.global_transform = posicion_explosion


	# ==========================================
	# ACTIVAR LA EXPLOSIÓN
	# ==========================================

	explosion.restart()
	explosion.emitting = true


	# Eliminar la copia cuando termine
	explosion.finished.connect(explosion.queue_free)


	# ==========================================
	# RESTAR UNA OPORTUNIDAD
	# ==========================================

	oportunidades -= 1

	print("================================")
	print("PELOTA PERDIDA")
	print("Oportunidades restantes: ", oportunidades)
	print("================================")


	# ==========================================
	# OCULTAR LA PELOTA
	# ==========================================

	visible = false

	# Desactivar temporalmente la colisión
	$CollisionShape3D.set_deferred("disabled", true)


	# ==========================================
	# TODAVÍA QUEDAN OPORTUNIDADES
	# ==========================================

	if oportunidades > 0:

		await get_tree().create_timer(0.8).timeout

		_reiniciar_pelota()

	else:

		# ======================================
		# SE ACABARON LAS OPORTUNIDADES
		# ======================================

		print("GAME OVER")

		state = GameState.GameOver


func _reiniciar_pelota() -> void:

	# ==========================================
	# VOLVER A LA POSICIÓN INICIAL
	# ==========================================

	global_position = initPosition


	# ==========================================
	# DETENER MOVIMIENTO
	# ==========================================

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO


	# ==========================================
	# MOSTRAR LA PELOTA
	# ==========================================

	visible = true


	# Reactivar la colisión
	$CollisionShape3D.set_deferred("disabled", false)


	# Volver al estado de espera
	state = GameState.Idle


	# Permitir detectar otra caída
	perdiendo_vida = false


	print("Pelota reiniciada")
	print("Oportunidades actuales: ", oportunidades)


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:

	# No utilizamos la salida de pantalla para perder oportunidades.
	# Las oportunidades se pierden al tocar SueloMapa.

	pass
	
	
