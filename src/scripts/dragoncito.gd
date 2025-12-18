extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var puntos_de_patron : Node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED : int = 1500
var muerte_de_enemigo = preload("res://src/escenas/Personajes/muerte_de_enemigo.tscn")
@onready var sprite_muerte: AnimatedSprite2D = $AnimatedSprite2D



const JUMP_VELOCITY = -400.0
enum State {idle, golpeado}
var current_state : State
var direccion : Vector2 = Vector2.LEFT
var numero_de_puntos : int
var posicion_de_puntos : Array[Vector2]
var punto_actual : Vector2
var posicion_punto_actual :  int
var vida : int = 3


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


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Hurtbox funciona")
	if area.get_parent().has_method("obtener_cantidad_daño"):
		var node = area.get_parent() as Node
		vida -= node.obtener_cantidad_daño()
		print("Vida restaante: ", vida)
		if vida <= 0:
			var efecto_muerte_enemigo = muerte_de_enemigo.instantiate() as Node2D
			efecto_muerte_enemigo.global_position = sprite_muerte.global_position
			get_parent().add_child(efecto_muerte_enemigo)
			queue_free()
