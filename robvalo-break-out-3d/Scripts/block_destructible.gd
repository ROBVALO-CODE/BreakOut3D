class_name Block extends StaticBody3D
#Crea la clase Block para diferenciarlo de los
#demas elementos.
const POWER_UP_SCENE := preload("res://Scenes/power_up_alargar.tscn")
@export var vida: float = 1.0

# Se activa solamente en el bloque
# que debe entregar el DuplicateBall.
@export var drops_duplicateball: bool = false

# Se activa en los bloques que deben entregar
# una vida adicional.
@export var drops_extralife: bool = false
@export var tiene_power_up: bool = false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var particulas_impacto: GPUParticles3D = $ParticulasImpacto
@onready var sonido_rotura: AudioStreamPlayer3D = $SonidoRotura
@export_range(0.0, 1.0) var probabilidad_power_up: float = 0.15


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
	_soltar_power_up()
	
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
	
func _soltar_power_up() -> void:
	if not tiene_power_up:
		return
	var p := POWER_UP_SCENE.instantiate()
	p.position = position
	get_parent().add_child.call_deferred(p)
