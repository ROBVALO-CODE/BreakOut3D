class_name Efectos
extends RefCounted

## Hace parpadear cualquier propiedad de color de cualquier objeto y la
## regresa a su valor original.
static func flash(objetivo: Object, propiedad: String, color: Color, duracion: float, quien_llama: Node) -> bool:
	if objetivo == null or quien_llama == null:
		return false
	var color_original = objetivo.get(propiedad)
	var tween := quien_llama.create_tween()
	tween.tween_property(objetivo, propiedad, color, duracion)
	tween.tween_property(objetivo, propiedad, color_original, duracion)
	return true

## Dispara una ráfaga de partículas ya configurada (GPUParticles3D con one_shot = true).
static func particulas(sistema: GPUParticles3D) -> bool:
	if sistema == null:
		return false
	sistema.restart()
	sistema.emitting = true
	return true
