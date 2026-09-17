class_name Raqueta extends CharacterBody3D

const SPEED = 9.0
@onready var rebote: AudioStreamPlayer3D = $rebote
@onready var detector_golpe: Area3D = $DetectorGolpe

func _ready() -> void:
	detector_golpe.body_entered.connect(_on_detector_golpe_body_entered)

func _physics_process(delta: float) -> void:
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
