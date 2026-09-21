extends Node3D

@onready var explosion: GPUParticles3D = $GPUParticles3D
@onready var linea_perdida: Marker3D = $LineaPerdida
@export var muerte : OmniLight3D

func disparar_explosion(pos: Vector3) -> void:
	var pos_visible:= pos
	pos_visible.z = linea_perdida.global_position.z
	pos_visible.y = linea_perdida.global_position.y
	# Dejamos pos_visible.x = pos.x, para que salga alineado con
	# por dónde se coló la pelota
	print("Explosión en: ", pos_visible)
	explosion.global_position = pos_visible
	Efectos.particulas(explosion)
	#aqui hago que la luz que puse abajo aparezca solo cuando muera (o pues caiga la pelota)
	if muerte:
		muerte.visible = true
	#esto volverá a apagar la luz al morir luego de lo que diga el timer
	await  get_tree().create_timer(0.2).timeout
	if muerte:
		muerte.visible = false
	

func _ready() -> void:
	if muerte:
		muerte.visible = false
	var scene_path := get_tree().current_scene.scene_file_path
	if scene_path.ends_with("nivel2.tscn"):
		MusicPlayer.play_track(preload("res://Audio/Audio_niveles/aundio_1.mp3"), -8.0)
	else:
		MusicPlayer.play_track(preload("res://Audio/Audio_niveles/aundio_1.mp3"), -8.0)
