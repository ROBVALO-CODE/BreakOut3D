class_name Pelota extends RigidBody3D

enum GameState { Idle, Playing, GameOver }

var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"

@onready var mesh: MeshInstance3D = find_child("MeshInstance3D", true) as MeshInstance3D
@onready var colision: CollisionShape3D = find_child("CollisionShape3D", true) as CollisionShape3D
@onready var particulas: GPUParticles3D = find_child("GPUParticles3D", true) as GPUParticles3D


func _ready() -> void:

	# ACTIVAR DETECCIÓN DE COLISIONES
	contact_monitor = true
	max_contacts_reported = 10

	# Conectar la señal desde código
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	print("✅Pelota lista")
	print("Contact Monitor: ", contact_monitor)
	print("Partículas encontradas: ", particulas != null)
	print("Mesh encontrada: ", mesh != null)
	print("Colisión encontrada: ", colision != null)


func _physics_process(_delta: float) -> void:

	match state:

		GameState.Idle:

			if Input.is_action_just_pressed("ui_accept"):
				state = GameState.Playing
				linear_velocity = initvelocity


		GameState.Playing:

			if linear_velocity.length() > 0.0:

				moveDirection = linear_velocity.normalized()

				linear_velocity = ballSpeed * moveDirection

				angular_velocity = ballSpeed * Vector3.UP.cross(moveDirection)


		GameState.GameOver:

			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO


func _integrate_forces(_physics_state: PhysicsDirectBodyState3D) -> void:

	if state == GameState.Idle:

		position = initPosition
		position.x = raqueta.position.x


func _on_body_entered(body: Node) -> void:

	print("================================")
	print(" LA PELOTA CHOCÓ CON:")
	print(body.name)
	print("TIPO: ", body.get_class())
	print("================================")


	# ==========================================
	# BLOQUES
	# ==========================================

	if body.has_method("recibir_dano"):

		print(" GOLPEÓ UN BLOQUE")

		body.recibir_dano(1.0)


	# ==========================================
	# PISO
	# ==========================================

	if body.is_in_group("suelo"):

		print(" PISO DETECTADO POR GRUPO")

		destruir_pelota()

	elif body.name == "PisoVerde":

		print(" PISO DETECTADO POR NOMBRE")

		destruir_pelota()

	elif body.name == "StaticBody3D":

		print(" STATICBODY3D DETECTADO")

		destruir_pelota()


func destruir_pelota() -> void:

	# Evitar que se ejecute dos veces
	if state == GameState.GameOver:
		return

	state = GameState.GameOver

	print(" DESTRUYENDO PELOTA ")


	# Detener movimiento
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO


	# Desactivar colisión
	if colision != null:

		colision.set_deferred("disabled", true)

		print("Colisión de pelota desactivada")


	# Ocultar pelota
	if mesh != null:

		mesh.visible = false

		print("Pelota oculta")


	# EXPLOSIÓN
	if particulas != null:

		print("LANZANDO PARTÍCULAS")

		particulas.global_position = global_position

		particulas.restart()

		particulas.emitting = true

		await particulas.finished

		print("PARTÍCULAS TERMINARON")

	else:

		print(" NO SE ENCONTRARON LAS PARTÍCULAS")


	print("🗑️ ELIMINANDO PELOTA")

	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:

	if state != GameState.GameOver:

		state = GameState.Idle

		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
