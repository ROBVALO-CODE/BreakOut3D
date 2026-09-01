class_name Block extends StaticBody3D
#Crea la clase Block para diferenciarlo de los
#demas elementos.

@export var vida: float = 1.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var particulas_impacto: GPUParticles3D = $ParticulasImpacto

## Le hace daño al bloque. Cualquier cosa del juego puede llamarla sin
## saber nada de cómo funciona por dentro. Devuelve la vida restante.
func recibir_dano(cantidad: float) -> float:
	vida = max(vida - cantidad, 0.0)

	var material := mesh.get_surface_override_material(0) as StandardMaterial3D
	Efectos.flash(material, "albedo_color", Color.WHITE, 0.08, self)
	Efectos.particulas(particulas_impacto)

	if vida <= 0.0:
		_liberar_particulas_y_destruir()

	return vida

## Saca las partículas del bloque antes de borrarlo, para que la animación
## termine de reproducirse aunque el bloque ya no exista.
func _liberar_particulas_y_destruir() -> void:
	var pos_global := particulas_impacto.global_transform
	remove_child(particulas_impacto)
	get_tree().root.add_child(particulas_impacto)
	particulas_impacto.global_transform = pos_global
	particulas_impacto.finished.connect(particulas_impacto.queue_free)
	queue_free()
