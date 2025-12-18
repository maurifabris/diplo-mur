extends CharacterBody2D

@export var velocidad: float = 120.0
@export var direccion: Vector2 = Vector2.RIGHT
@export var margen_llegada: float = 2.0

@onready var fin: Marker2D = $Fin


var fin_pos_global: Vector2

func _ready():
	direccion = direccion.normalized()
	# Guardamos la posición real del marker al inicio
	fin_pos_global = fin.global_position

func _physics_process(delta):
	global_position += direccion * velocidad * delta

	# Cuando alcanza el recorrido marcado → destruir
	if global_position.distance_to(fin_pos_global) <= margen_llegada:
		queue_free()
