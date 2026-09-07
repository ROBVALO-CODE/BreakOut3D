class_name Efectos
extends RefCounted

## Dispara una ráfaga de partículas ya configurada en la escena. No crea
## nada nuevo: solo reinicia el sistema y lo prende, para poder llamarlo
## varias veces seguidas sin que la ráfaga anterior se pierda.
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

## Reproduce un sonido puntual en 3D sin cortar las reproducciones previas,
## instanciando una copia temporal que se libera al terminar.
static func sonido(reproductor: AudioStreamPlayer3D) -> bool:
	if reproductor == null or reproductor.stream == null:
		return false

	var copia := reproductor.duplicate() as AudioStreamPlayer3D
	reproductor.get_parent().add_child(copia)
	copia.finished.connect(copia.queue_free)
	copia.play()
	return true
