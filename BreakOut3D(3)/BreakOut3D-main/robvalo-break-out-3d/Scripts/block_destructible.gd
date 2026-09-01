class_name Block extends StaticBody3D
#Crea la clase Block para diferenciarlo de los
#demas elementos.

@export var vida: float = 1.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var particulas_impacto: GPUParticles3D = $ParticulasImpacto
@onready var sonido_rotura: AudioStreamPlayer3D = $SonidoRotura

## Le hace daño al bloque. Cualquier cosa del juego puede llamarla sin
## saber nada de cómo funciona por dentro. Devuelve la vida restante.
func recibir_dano(cantidad: float) -> float:
	vida = max(vida - cantidad, 0.0)

	var material := mesh.get_surface_override_material(0) as StandardMaterial3D
	Efectos.flash(material, "albedo_color", Color.WHITE, 0.08, self)
	Efectos.particulas(particulas_impacto)

	if vida <= 0.0:
		_liberar_efectos_y_destruir()

	return vida

## Saca las particulas y el sonido del bloque antes de borrarlo, para que
## la animación y el audio terminen aunque el bloque ya no exista.
func _liberar_efectos_y_destruir() -> void:
	var pos_global := particulas_impacto.global_transform
	remove_child(particulas_impacto)
	get_tree().root.add_child(particulas_impacto)
	particulas_impacto.global_transform = pos_global
	particulas_impacto.finished.connect(particulas_impacto.queue_free)

	remove_child(sonido_rotura)
	get_tree().root.add_child(sonido_rotura)
	sonido_rotura.global_transform = pos_global
	Efectos.sonido(sonido_rotura)
	sonido_rotura.finished.connect(sonido_rotura.queue_free)

	queue_free()
