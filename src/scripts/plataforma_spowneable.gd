extends CharacterBody2D

@export var direccion: Vector2 = Vector2.RIGHT
@export var distancia_pixeles: float = 128.0
@export var velocidad: float = 60.0
@export var tiempo_pausa_antes_despawn: float = 1.0
@export var tiempo_inactivo: float = 1.5

@onready var colision: CollisionShape2D = $CollisionShape2D

var posicion_inicial: Vector2
var distancia_recorrida := 0.0
var activa := true
var cuerpos_encima := 0
var esperando_despawn := false

func _ready():
	posicion_inicial = global_position
	direccion = direccion.normalized()

func _physics_process(delta):
	if not activa or esperando_despawn:
		return

	var desplazamiento = direccion * velocidad * delta
	move_and_collide(desplazamiento)

	distancia_recorrida += desplazamiento.length()

	if distancia_recorrida >= distancia_pixeles:
		iniciar_pausa_despawn()

func iniciar_pausa_despawn():
	if esperando_despawn:
		return

	esperando_despawn = true
	velocity = Vector2.ZERO

	await get_tree().create_timer(tiempo_pausa_antes_despawn).timeout
	desactivar()

func desactivar():
	activa = false
	esperando_despawn = false

	visible = false
	colision.disabled = true

	# Esperar a que el jugador se vaya
	while cuerpos_encima > 0:
		await get_tree().physics_frame

	# Tiempo antes de respawn
	await get_tree().create_timer(tiempo_inactivo).timeout

	reiniciar()

func reiniciar():
	global_position = posicion_inicial
	distancia_recorrida = 0.0
	visible = true
	colision.disabled = false
	activa = true
