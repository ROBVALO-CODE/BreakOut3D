class_name Pelota extends RigidBody3D

enum GameState {Idle, Playing, GameOver}
var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."
@onready var particulas_impacto: GPUParticles3D = $particulas_impacto


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
	# Si la pelota toca el suelo, explota
	if body.name == "SueloMapa":
		_explotar()
		return

	# Si la pelota toca un bloque, mantiene el comportamiento actual

	if body.has_method("recibir_dano"):
		var block := body as Block
		var vida_restante: float = block.recibir_dano(1.0)

		if vida_restante <= 0.0 and bloques.get_child_count() == 1:
			state = GameState.GameOver


func _explotar() -> void:
	# Detener la pelota
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Guardar la posición de las partículas
	var posicion_explosion := particulas_impacto.global_transform

	# Sacar las partículas de la pelota
	remove_child(particulas_impacto)

	# Agregar las partículas directamente al nivel
	get_tree().current_scene.add_child(particulas_impacto)

	# Mantener las partículas en la posición de la pelota
	particulas_impacto.global_transform = posicion_explosion

	# Activar las partículas
	particulas_impacto.restart()
	particulas_impacto.emitting = true

	# Eliminar las partículas cuando terminen
	particulas_impacto.finished.connect(particulas_impacto.queue_free)

	# Eliminar la pelota
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	state = GameState.Idle
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
