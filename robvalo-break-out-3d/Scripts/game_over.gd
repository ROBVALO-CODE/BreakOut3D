extends Control

@onready var retry_button: Button = $RETRY
@onready var exit_button: Button = $EXIT


func _ready() -> void:
	# Por si llegamos aquí con el juego pausado
	get_tree().paused = false

	retry_button.pressed.connect(_on_retry_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _on_retry_pressed() -> void:
	SceneManager.change_scene(SceneManager.last_level_path)


func _on_exit_pressed() -> void:
	get_tree().quit()
