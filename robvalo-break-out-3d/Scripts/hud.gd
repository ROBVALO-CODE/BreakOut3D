extends Control

@export var lives: int = 3
#Importar una variable vidas con la cantidad de vidas
#con las que interactuara en el juego y la misma que 
#se encuentra en el label
@onready var label: Label = $Label
# Crea una referencia al nodo label en el HUD y 
#una al nodo Pelota dentro de la jerarquía del juego
@onready var ball: Pelota = get_node("/root/Nivel/Pelota")
#

func _ready() -> void:
	#Si las vidas empiezan en 0 o menos actualiza el
	#HUD a 3 vidas
	if lives <= 0:
		lives = 3
	update_hud()
	
	if ball:
		#Conecta el notificador de la Pelota con screen_exited
		#para asegurarse de que avise cuando la pelota salga de
		#la vista de acuerdo a lo establecido en los parametros
		var notifier = ball.get_node("VisibleOnScreenNotifier3D")
		if notifier and not notifier.is_connected("screen_exited", Callable(self, "_on_ball_exited")):
			notifier.connect("screen_exited", Callable(self, "_on_ball_exited"))

func _on_ball_exited() -> void:
	#Cuando la pelota salga de la vista restar una vida a lives
	#y actualizar el hud
	lives -= 1
	update_hud()
	
	if lives <= 0:
		#Si las vidas de la pelota son iguales a 0 o menor cambia
		#el estado de pelota a GameOver haciendo que de acuerdo a
		#los parametros de pelota esta no siga su movimientoal salir
		#de la pantalla, de tal manera que la pelota no vuelve a su
		#posicion inicial dando a entender el fin de la partida por GameOver
		if ball:
			ball.state = Pelota.GameState.GameOver
			
func update_hud() -> void:
	if label:
		label.text = "x " + str(lives)
