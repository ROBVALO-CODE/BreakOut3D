class_name Pelota extends RigidBody3D

signal block_destroyed

enum GameState {Idle, Playing, GameOver}
var state: GameState = GameState.Idle

var moveDirection: Vector3
var ballSpeed: float = 10.0
var initvelocity: Vector3 = ballSpeed * Vector3.FORWARD

@onready var initPosition: Vector3 = position
@onready var raqueta: Raqueta = $"../Raqueta"
@onready var bloques: Node3D = $"../Bloques"
@onready var nivel: Node3D = $".."

func _ready() -> void:
	# Aumentar la velocidad automáticamente si el archivo actual es nivel2.tscn
	if get_tree().current_scene.scene_file_path.ends_with("nivel2.tscn"):
		ballSpeed = 14.0 # Subimos la velocidad de 10.0 a 14.0 para el Nivel 2
		initvelocity = ballSpeed * Vector3.FORWARD

func _physics_process(delta: float) -> void:
	match state:
		GameState.Idle:
			if Input.is_action_just_pressed("ui_accept"):
				state = GameState.Playing
				linear_velocity = initvelocity
		GameState.Playing:
			moveDirection = linear_velocity.normalized()
			linear_velocity = ballSpeed * moveDirection
			angular_velocity = ballSpeed * Vector3.UP.cross(moveDirection)
		GameState.GameOver:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			
func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if state == GameState.Idle:
		position = initPosition
		position.x = raqueta.position.x

func _on_body_entered(body: Node) -> void:
	if body is Block:
    var block := body as Block
		var vida_restante: float = block.recibir_dano(1.0)
		
		# Si la vida llega a 0, el bloque destruido emite la señal
		if vida_restante <= 0.0:
            block_destroyed.emit()
			
			      # Cuando quede solo 1 bloque (el que se acaba de destruir)
			if bloques.get_child_count() <= 1:
				if get_tree().current_scene.scene_file_path.ends_with("nivel2.tscn"):
					state = GameState.GameOver
				else:
					get_tree().change_scene_to_file("res://Scenes/nivel2.tscn")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	nivel.disparar_explosion(global_position)
	state = GameState.Idle
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
