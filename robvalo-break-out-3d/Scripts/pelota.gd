class_name Pelota extends RigidBody3D

enum GameState {Idle, Playing, GameOver}
var state:GameState = GameState.Idle

var moveDirection:Vector3
var ballSpeed:float = 10.0
var initvelocity:Vector3 = ballSpeed * Vector3.FORWARD

@onready var initPosition:Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."
@onready var mesh = $CSGBakedMeshInstance3D
@onready var colision = $CollisionShape3D
@onready var particulas = $GPUParticles3D


func _ready() -> void: particulas.finished.connect(queue_free)

func _physics_process(delta: float) -> void:
	match state:
		GameState.Idle:
			if Input.is_action_just_pressed("ui_accept"):
				state =GameState.Playing
				linear_velocity =initvelocity
		GameState.Playing:
			moveDirection = linear_velocity.normalized()
			linear_velocity =ballSpeed * moveDirection
			angular_velocity =ballSpeed * Vector3.UP.cross(moveDirection)
		GameState.GameOver:
			linear_velocity =Vector3.ZERO
			angular_velocity=Vector3.ZERO
			
func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if state == GameState.Idle:
		position = initPosition
		position.x =raqueta.position.x
		

func _on_body_entered(body: Node) -> void:
	print("La pelota chocó con: ", body.name, " | Tipo: ", body.get_class())
	
	if body is Block:
		body.queue_free()
		if bloques.get_child_count() == 1:
			state = GameState.GameOver

	if body.is_in_group("suelo"):
		mesh.visible = false
		colision.set_deferred("disabled", true)
		particulas.emitting = true

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	state =GameState.Idle
	linear_velocity =Vector3.ZERO
	angular_velocity =Vector3.ZERO
	
