class_name Efectos
extends RefCounted

## Dispara una ráfaga de particulas ya configurada en la escena. No crea
## nada nuevo: solo reinicia el sistema y lo prende, para poder llamarlo
## varias veces seguidas (dos golpes casi al mismo tiempo) sin que la
## segunda ráfaga se pierda.
static func particulas(sistema: GPUParticles3D) -> bool:
	if sistema == null:
		return false
	sistema.restart()
	sistema.emitting = true
	return true

## Hace parpadear cualquier propiedad de color de cualquier objeto y la
## regresa a su valor original. objetivo: el dueño de la propiedad
## (un StandardMaterial3D, un ColorRect...). propiedad: su nombre, como
## texto. color: a qué cambia. duracion: cuánto dura CADA MITAD del
## parpadeo. quien_llama: cualquier Node vivo — create_tween() necesita
## un dueño. Devuelve true si alcanzó a programarlo.
static func flash(objetivo: Object, propiedad: String, color: Color,
		duracion: float, quien_llama: Node) -> bool:
	if objetivo == null or quien_llama == null:
		return false

	var color_original = objetivo.get(propiedad)

	var tween := quien_llama.create_tween()
	tween.tween_property(objetivo, propiedad, color, duracion)
	tween.tween_property(objetivo, propiedad, color_original, duracion)
	return true

## Reproduce un sonido puntual en 3D. sonido: el AudioStreamPlayer3D ya
## configurado en la escena (con su AudioStream asignado). Se puede llamar
## varias veces seguidas sin que un sonido corte al anterior, porque no
## reusa el nodo si ya está sonando: usa una copia temporal.
static func sonido(reproductor: AudioStreamPlayer3D) -> bool:
	if reproductor == null or reproductor.stream == null:
		return false
	reproductor.play()
	return true
