extends DirectionalLight3D

# Variable para controlar la velocidad del cambio de color
@export var velocidad_cambio: float = 0.001

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# Obtenemos el tiempo transcurrido en milisegundos
	var tiempo = Time.get_ticks_msec() * velocidad_cambio
	
	# Creamos un color que va cambiando usando ondas senoidales para R, G y B
	var r = (sin(tiempo) + 1.0) / 2.0
	var g = (sin(tiempo + 2.0) + 1.0) / 2.0
	var b = (sin(tiempo + 4.0) + 1.0) / 2.0
	
	# Como este script es de la luz, cambiamos su color directamente
	light_color = Color(r, g, b)
