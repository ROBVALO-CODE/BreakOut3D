class_name Raqueta extends CharacterBody3D

const SPEED = 9.0
const ESCALA_NORMAL := 1.0
const INCREMENTO := 0.4
const ESCALA_MAXIMA := 3.0
const ESCALA_ALARGADA := 1.6
const DURACION_POWERUP := 30.0

@onready var rebote: AudioStreamPlayer3D = $rebote
@onready var detector_golpe: Area3D = $DetectorGolpe
@onready var timer_powerup: Timer = $TimerPowerUp

var _escala_objetivo := ESCALA_NORMAL
var _tween: Tween

func _ready() -> void:
	detector_golpe.body_entered.connect(_on_detector_golpe_body_entered)
	detector_golpe.area_entered.connect(_on_detector_golpe_area_entered)
	timer_powerup.timeout.connect(_restaurar)

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_detector_golpe_body_entered(body: Node) -> void:
	if body is Pelota:
		rebote.play()

func _on_detector_golpe_area_entered(area: Area3D) -> void:
	if area is PowerUpAlargar:
		alargar()
		area.recoger()

func alargar() -> void:
	_escala_objetivo = min(_escala_objetivo + INCREMENTO, ESCALA_MAXIMA)
	_cambiar_escala(_escala_objetivo)
	timer_powerup.start(DURACION_POWERUP)  # cada power-up reinicia el tiempo

func _restaurar() -> void:
	_escala_objetivo = ESCALA_NORMAL
	_cambiar_escala(ESCALA_NORMAL)

func _cambiar_escala(x: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "scale:x", x, 0.3)
