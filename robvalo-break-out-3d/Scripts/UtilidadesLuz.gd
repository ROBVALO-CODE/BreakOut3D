class_name UtilidadesLuz

static func cambiar_luz(luz: Light3D, propiedad: String, valor) -> bool:
	if luz == null:
		return false
	luz.set(propiedad, valor)
	return true
