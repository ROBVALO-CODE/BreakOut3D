extends Area3D

@onready var forma: CollisionShape3D = $CollisionShape3D
@onready var particulas_impacto: GPUParticles3D = $"../ParticulasImpacto"

func _ready() -> void:
	forma.set_deferred("disabled", false)
	body_entered.connect(_al_entrar)

func _al_entrar(cuerpo: Node3D) -> void:
	Efectos.particulas(particulas_impacto)
