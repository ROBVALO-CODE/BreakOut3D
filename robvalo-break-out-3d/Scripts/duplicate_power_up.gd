class_name DuplicateBallPowerUp
extends Area3D


@export var fall_speed: float = 4.0
@export var fall_direction: Vector3 = Vector3.BACK


var recogido: bool = false


func _physics_process(delta: float) -> void:
	if recogido:
		return

	# Hace caer el power-up.
	global_position += (
		fall_direction.normalized()
		* fall_speed
		* delta
	)


func _on_body_entered(body: Node3D) -> void:
	if recogido:
		return

	# Solamente la raqueta lo recoge.
	if not body is Raqueta:
		return

	recogido = true

	var managers := (
		get_tree()
		.get_nodes_in_group("ball_manager")
	)

	if not managers.is_empty():
		managers[0].duplicate_ball()

	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
