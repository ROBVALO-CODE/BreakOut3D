extends Node


# El HUD recibe esta señal para restar
# exactamente una vida.
signal round_lost

# El HUD recibe esta señal para sumar puntos.
signal any_block_destroyed


# Escena de la pelota y del power-up.
@export var ball_scene: PackedScene
@export var power_up_scene: PackedScene

# Ángulo de separación de la copia.
@export var separation_angle: float = 25.0


@onready var nivel: Node3D = get_parent()

@onready var pelota_original: Pelota = (
	nivel.get_node("Pelota") as Pelota
)


# Indican cuáles pelotas continúan jugando.
var original_activa: bool = true
var copia_activa: bool = false

# Referencia a la pelota duplicada.
var pelota_copia: Pelota = null

# Evita reiniciar dos veces.
var reiniciando: bool = false

# Guarda las colisiones de la original.
var capa_original: int
var mascara_original: int


func _ready() -> void:
	# El power-up encuentra el administrador
	# utilizando este grupo.
	add_to_group("ball_manager")

	if pelota_original == null:
		push_error(
			"No se encontró Pelota en el nivel."
		)
		return

	# Identifica la pelota principal.
	pelota_original.es_copia = false

	# Guarda sus colisiones originales.
	capa_original = (
		pelota_original.collision_layer
	)

	mascara_original = (
		pelota_original.collision_mask
	)

	conectar_pelota(pelota_original)


func conectar_pelota(pelota: Pelota) -> void:
	# Escucha cuándo sale del tablero.
	if not pelota.ball_exited.is_connected(
		_on_ball_exited
	):
		pelota.ball_exited.connect(
			_on_ball_exited
		)

	# Escucha los bloques que destruye.
	if not pelota.block_destroyed.is_connected(
		_on_block_destroyed
	):
		pelota.block_destroyed.connect(
			_on_block_destroyed
		)


func duplicate_ball() -> void:
	print("BallManager recibió duplicate_ball()")

	# Evita crear más de una copia.
	if copia_activa:
		print("Ya existe una pelota duplicada.")
		return

	# Comprueba que pelota.tscn esté asignada.
	if ball_scene == null:
		push_error(
			"No se asignó pelota.tscn "
			+ "en Ball Scene."
		)
		return

	print("Ball Scene está correctamente asignada.")

	# Para este power-up se utiliza directamente
	# la pelota original como referencia.
	if not is_instance_valid(pelota_original):
		push_error(
			"La pelota original no es válida."
		)
		return

	print(
		"Estado de la pelota original: ",
		pelota_original.state
	)

	# Crea la nueva pelota.
	var nueva_pelota := (
		ball_scene.instantiate() as Pelota
	)

	if nueva_pelota == null:
		push_error(
			"Ball Scene no contiene una Pelota. "
			+ "Debes asignar pelota.tscn."
		)
		return

	print("Pelota.tscn fue instanciada.")

	# Agrega la copia al nivel.
	nivel.add_child(nueva_pelota)

	# La coloca donde está la pelota original.
	nueva_pelota.global_transform = (
		pelota_original.global_transform
	)

	# La separa ligeramente para poder verla.
	nueva_pelota.global_position.x += 0.7

	# La identifica como una copia.
	nueva_pelota.es_copia = true
	nueva_pelota.salida_reportada = false
	nueva_pelota.visible = true

	# Copia la configuración de colisiones.
	nueva_pelota.collision_layer = (
		pelota_original.collision_layer
	)

	nueva_pelota.collision_mask = (
		pelota_original.collision_mask
	)

	# Toma la dirección actual de la original.
	var direccion: Vector3 = (
		pelota_original
		.linear_velocity
		.normalized()
	)

	if direccion == Vector3.ZERO:
		direccion = Vector3.FORWARD

	# Cambia ligeramente la dirección.
	var direccion_copia: Vector3 = (
		direccion.rotated(
			Vector3.UP,
			deg_to_rad(separation_angle)
		).normalized()
	)

	# La copia empieza jugando.
	nueva_pelota.state = (
		Pelota.GameState.Playing
	)

	nueva_pelota.linear_velocity = (
		direccion_copia
		* nueva_pelota.ballSpeed
	)

	# Guarda la copia en BallManager.
	pelota_copia = nueva_pelota
	copia_activa = true

	# Conecta las señales de la copia.
	conectar_pelota(nueva_pelota)

	print(
		"Pelota duplicada creada correctamente en: ",
		nueva_pelota.global_position
	)


func buscar_pelota_activa() -> Pelota:
	# Primero intenta utilizar la original.
	if (
		original_activa
		and is_instance_valid(pelota_original)
		and pelota_original.state
		== Pelota.GameState.Playing
	):
		return pelota_original

	# Si la original cayó, puede duplicar
	# la copia que todavía siga jugando.
	if (
		copia_activa
		and is_instance_valid(pelota_copia)
		and pelota_copia.state
		== Pelota.GameState.Playing
	):
		return pelota_copia

	return null


func _on_ball_exited(pelota: Pelota) -> void:
	# Detiene la pelota que cayó.
	pelota.state = Pelota.GameState.GameOver
	pelota.linear_velocity = Vector3.ZERO
	pelota.angular_velocity = Vector3.ZERO

	if pelota.es_copia:
		# La pelota duplicada se elimina.
		copia_activa = false
		pelota_copia = null
		pelota.queue_free()
	else:
		# La original se conserva oculta.
		original_activa = false
		pelota_original.visible = false
		pelota_original.collision_layer = 0
		pelota_original.collision_mask = 0

	# Si queda alguna pelota, no pierde vida.
	if original_activa or copia_activa:
		return

	# En este punto ya cayeron las dos.
	if reiniciando:
		return

	reiniciando = true

	# Reinicia fuera del proceso físico.
	call_deferred("reiniciar_ronda")


func reiniciar_ronda() -> void:
	# Restaura la pelota original.
	pelota_original.collision_layer = (
		capa_original
	)

	pelota_original.collision_mask = (
		mascara_original
	)

	pelota_original.prepare_for_new_round()

	original_activa = true
	copia_activa = false
	pelota_copia = null

	conectar_pelota(pelota_original)

	# Ahora el HUD descuenta una sola vida.
	round_lost.emit()

	reiniciando = false


func _on_block_destroyed(block: Block) -> void:
	# Suma puntos sin importar cuál
	# de las pelotas destruyó el bloque.
	any_block_destroyed.emit()

	# Solamente algunos bloques dan power-up.
	if not block.drops_duplicateball:
		return

	crear_power_up(
		block.global_position
	)


func crear_power_up(posicion: Vector3) -> void:
	if power_up_scene == null:
		push_warning(
			"No se asignó el power-up."
		)
		return

	var power_up := (
		power_up_scene.instantiate()
		as DuplicateBallPowerUp
	)

	if power_up == null:
		push_error(
			"La escena no tiene "
			+ "multi_ball_power_up.gd."
		)
		return

	call_deferred(
		"agregar_power_up",
		power_up,
		posicion
	)


func agregar_power_up(
	power_up: DuplicateBallPowerUp,
	posicion: Vector3
) -> void:
	# Lo agrega directamente al nivel.
	nivel.add_child(power_up)

	# Aparece donde estaba el bloque.
	power_up.global_position = posicion
