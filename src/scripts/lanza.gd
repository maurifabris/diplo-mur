extends AnimatedSprite2D

var speed : int = 600
var direction : int
var daño: int = 1


var lanza_impacto_efecto = preload("res://src/escenas/Personajes/golpe_de_lanza.tscn")


func _physics_process(delta: float) -> void:
	global_position.x += (direction * speed * delta)
	if direction == 1:
		rotation_degrees = 45
	else:
		rotation_degrees = 225
		
	

func _on_timer_timeout() -> void:
	queue_free()

func obtener_cantidad_daño () -> int:
	return daño


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Lanza entro al area")
	lanza_inpacta()
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("lanza body entro")
	lanza_inpacta()


func lanza_inpacta():
	var efecto = lanza_impacto_efecto.instantiate() as AnimatedSprite2D
	efecto.global_position = global_position
	
	# SOLO copiamos la rotación
	efecto.rotation = rotation
	
	get_parent().add_child(efecto)
	queue_free()
