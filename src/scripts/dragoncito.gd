extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var puntos_de_patron : Node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED : int = 1500
  



const JUMP_VELOCITY = -400.0
enum State {idle, golpeado}
var current_state : State
var direccion : Vector2 = Vector2.LEFT
var numero_de_puntos : int
var posicion_de_puntos : Array[Vector2]
var punto_actual : Vector2
var posicion_punto_actual :  int



func _ready() -> void:
	if puntos_de_patron != null:
		numero_de_puntos = puntos_de_patron.get_children().size()
		for punto in puntos_de_patron.get_children():
			posicion_de_puntos.append(punto.global_position)
		punto_actual = posicion_de_puntos[posicion_punto_actual]
	else:
		print("No hay puntos de patron")
	
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	movimiento_enemigo(delta)


	move_and_slide()

func movimiento_enemigo(delta: float):
	if abs(position.x - punto_actual.x) > 0.5:
		velocity.x = direccion.x * SPEED * delta
		current_state = State.idle
	else:
		posicion_punto_actual += 1
		if posicion_punto_actual >= posicion_de_puntos.size():
			posicion_punto_actual = 0
		punto_actual = posicion_de_puntos[posicion_punto_actual]

	if punto_actual.x > position.x:
		direccion = Vector2.RIGHT
	else:
		direccion = Vector2.LEFT
	animated_sprite_2d.flip_h = direccion.x > 0
