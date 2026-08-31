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
	if body is Block:
		body.queue_free()
		if bloques.get_child_count()== 1:
			state = GameState.GameOver
	


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	state =GameState.Idle
	linear_velocity =Vector3.ZERO
	angular_velocity =Vector3.ZERO
	
