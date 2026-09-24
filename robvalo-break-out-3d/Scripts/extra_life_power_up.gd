class_name ExtraLifePowerUp
extends Area3D


# Velocidad y dirección de caída.
@export var fall_speed: float = 4.0
@export var fall_direction: Vector3 = Vector3.BACK


# Evita recoger dos veces el mismo power-up.
var recogido: bool = false


func _physics_process(delta: float) -> void:
	if recogido:
		return

	# Mueve el corazón hacia la raqueta.
	global_position += (
		fall_direction.normalized()
		* fall_speed
		* delta
	)


func _on_body_entered(body: Node3D) -> void:
	if recogido:
		return

	# Solamente la raqueta puede recogerlo.
	if not body is Raqueta:
		return

	recogido = true

	# Busca el administrador de las pelotas
	# y le informa que se ganó una vida.
	var managers := (
		get_tree()
		.get_nodes_in_group("ball_manager")
	)

	if not managers.is_empty():
		managers[0].give_extra_life()
	else:
		push_warning(
			"No se encontró BallManager."
		)

	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# Elimina el corazón si sale de la pantalla.
	if not recogido:
		queue_free()
