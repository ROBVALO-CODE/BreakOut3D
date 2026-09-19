extends Control

# Señal para avisarle al menú de pausa que esta pantalla se cerró
signal closed

@onready var master_slider: HSlider = $BoxContainer/MasterRow/MasterSlider
@onready var music_slider: HSlider = $BoxContainer2/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $BoxContainer3/SfxRow/SfxSlider

const SAVE_PATH := "user://settings.cfg"

var master_bus: int = AudioServer.get_bus_index("Master")
var music_bus: int = AudioServer.get_bus_index("Music")
var sfx_bus: int = AudioServer.get_bus_index("SFX")


func _ready() -> void:
	_load_settings()

	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)


func _on_master_changed(value: float) -> void:
	_set_bus_volume(master_bus, value)
	_save_settings()


func _on_music_changed(value: float) -> void:
	_set_bus_volume(music_bus, value)
	_save_settings()


func _on_sfx_changed(value: float) -> void:
	_set_bus_volume(sfx_bus, value)
	_save_settings()


func _set_bus_volume(bus_index: int, linear_value: float) -> void:
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))
	AudioServer.set_bus_mute(bus_index, linear_value <= 0.0)


func _on_back_button_pressed() -> void:
	closed.emit()
	if get_tree().current_scene.scene_file_path == "res://Scenes/UI/ajustes_volumen.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/menu_principal.tscn")


func _load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)

	var master_value: float = 1.0
	var music_value: float = 1.0
	var sfx_value: float = 1.0

	if err == OK:
		master_value = config.get_value("audio", "master", 1.0)
		music_value = config.get_value("audio", "music", 1.0)
		sfx_value = config.get_value("audio", "sfx", 1.0)

	master_slider.value = master_value
	music_slider.value = music_value
	sfx_slider.value = sfx_value

	_set_bus_volume(master_bus, master_value)
	_set_bus_volume(music_bus, music_value)
	_set_bus_volume(sfx_bus, sfx_value)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save(SAVE_PATH)
