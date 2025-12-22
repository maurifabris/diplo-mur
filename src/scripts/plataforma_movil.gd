extends Node2D

@export var dur_inact: float = 0.5
@export var mover_a: Vector2
@export var velocidad: float = 100.0

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D


var origen: Vector2
var destino: Vector2
var yendo := true
var esperando := false

func _ready():
	origen = character_body_2d.global_position
	destino = origen + mover_a

func _physics_process(delta):
	if esperando:
		return

	var objetivo = destino if yendo else origen
	var direccion = (objetivo - character_body_2d.global_position)

	if direccion.length() < 2:
		esperar_y_cambiar()
		return

	direccion = direccion.normalized()
	character_body_2d.velocity = direccion * velocidad
	character_body_2d.move_and_slide()

func esperar_y_cambiar():
	esperando = true
	character_body_2d.velocity = Vector2.ZERO
	await get_tree().create_timer(dur_inact).timeout
	yendo = !yendo
	esperando = false
