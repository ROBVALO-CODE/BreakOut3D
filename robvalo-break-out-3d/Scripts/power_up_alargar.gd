class_name PowerUpAlargar extends Area3D

const VELOCIDAD_CAIDA := 3.0

func _physics_process(delta: float) -> void:
	position.z += VELOCIDAD_CAIDA * delta  # ajusta el eje según tu escena

func recoger() -> void:
	queue_free()
