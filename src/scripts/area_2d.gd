extends Area2D

@onready var plataforma: PlataformaSpawneable = get_parent()

func _on_body_entered(body):
	if body is CharacterBody2D:
		plataforma.cuerpos_encima += 1

func _on_body_exited(body):
	if body is CharacterBody2D:
		plataforma.cuerpos_encima -= 1
