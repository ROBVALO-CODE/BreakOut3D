class_name Pelota extends RigidBody3D

enum GameState {Idle, Playing, GameOver}
var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

# Cantidad de oportunidades de la pelota
var oportunidades: int = 3

# Evita detectar varias veces la misma caída
var perdiendo_vida: bool = false

@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."

@onready var particulas_impacto: GPUParticles3D = $particulas_impacto
@onready var mesh: MeshInstance3D = $CSGBakedMeshInstance3D


func _physics_process(delta: float) -> void:
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

	# Si la pelota toca el suelo
	if body.name == "SueloMapa":
		if not perdiendo_vida:
			_perder_oportunidad()
		return

	# Si la pelota toca un bloque
	if body is Block:
		if body.has_method("recibir_dano"):
			var block := body as Block
			var vida_restante: float = block.recibir_dano(1.0)

			if vida_restante <= 0.0 and bloques.get_child_count() == 1:
				state = GameState.GameOver


func _perder_oportunidad() -> void:
	perdiendo_vida = true

	# Detener la pelota
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Guardar la posición donde cayó
	var posicion_explosion := particulas_impacto.global_transform

	# Sacar las partículas de la pelota
	remove_child(particulas_impacto)

	# Pasar las partículas al nivel
	get_tree().current_scene.add_child(particulas_impacto)

	# Mantener las partículas donde cayó la pelota
	particulas_impacto.global_transform = posicion_explosion

	# Reiniciar y activar las partículas
	particulas_impacto.restart()
	particulas_impacto.emitting = true

	# Eliminar las partículas cuando terminen
	particulas_impacto.finished.connect(particulas_impacto.queue_free)

	# Restar una oportunidad
	oportunidades -= 1

	print("Oportunidades restantes: ", oportunidades)

	# Ocultar la pelota
	mesh.visible = false
	$CollisionShape3D.set_deferred("disabled", true)

	# Si todavía quedan oportunidades
	if oportunidades > 0:
		await get_tree().create_timer(0.7).timeout
		_reiniciar_pelota()
	else:
		# Se acabaron las oportunidades
		state = GameState.GameOver


func _reiniciar_pelota() -> void:
	# Volver a la posición inicial
	global_position = initPosition

	# Mostrar la pelota nuevamente
	mesh.visible = true

	# Reactivar la colisión
	$CollisionShape3D.set_deferred("disabled", false)

	# Volver al estado inicial
	state = GameState.Idle

	# Detener movimiento
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Permitir detectar una nueva caída
	perdiendo_vida = false


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# La pérdida de oportunidades se controla al tocar SueloMapa
	pass
	
