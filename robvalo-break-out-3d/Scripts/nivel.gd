extends Node3D

@onready var explosion: GPUParticles3D = $GPUParticles3D
@onready var linea_perdida: Marker3D = $LineaPerdida

func disparar_explosion(pos: Vector3) -> void:
	var pos_visible:= pos
	pos_visible.z = linea_perdida.global_position.z
	pos_visible.y = linea_perdida.global_position.y
	# Dejamos pos_visible.x = pos.x, para que salga alineado con
	# por dónde se coló la pelota
	print("Explosión en: ", pos_visible)
	explosion.global_position = pos_visible
	Efectos.particulas(explosion)
