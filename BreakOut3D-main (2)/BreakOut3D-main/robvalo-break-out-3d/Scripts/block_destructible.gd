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
		queue_free()

	return vida
