class_name Efectos
extends RefCounted

## Dispara una ráfaga de partículas ya configurada en la escena. No crea
## nada nuevo: solo reinicia el sistema y lo prende, para poder llamarlo
## varias veces seguidas sin que la segunda ráfaga se pierda.
static func particulas(sistema: GPUParticles3D) -> bool:
	if sistema == null:
		return false
	sistema.restart()
	sistema.emitting = true
	return true

## Hace parpadear cualquier propiedad de color de cualquier objeto y la
## regresa a su valor original.
static func flash(objetivo: Object, propiedad: String, color: Color,
		duracion: float, quien_llama: Node) -> bool:
	if objetivo == null or quien_llama == null:
		return false

	var color_original = objetivo.get(propiedad)

	var tween := quien_llama.create_tween()
	tween.tween_property(objetivo, propiedad, color, duracion)
	tween.tween_property(objetivo, propiedad, color_original, duracion)
	return true
