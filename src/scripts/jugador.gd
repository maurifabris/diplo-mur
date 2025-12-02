extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED : int = 15002
@export var JUMP_VELOCITY : int = -400
@export var max_velocidad_horizontal: int = 300

enum State {idle, correr, salto, disparo}

var current_state : State

func _ready() -> void:
	current_state = State.idle
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	# --- PRIMERO: manejar entradas (disparo, salto, movimiento) ---
	jugador_disparo()  # revisar disparo antes que la gravedad
	# Salto (solo si no estamos en disparo)
	if current_state != State.disparo:
		if Input.is_action_just_pressed("saltar") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			current_state = State.salto

	# Movimiento horizontal (solo si no estamos en disparo)
	var direction := Input.get_axis("mover_izq", "mover_der")
	if current_state != State.disparo:
		if direction != 0:
			velocity.x = direction * SPEED * delta
			velocity.x = clamp(velocity.x, -max_velocidad_horizontal, max_velocidad_horizontal)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# ajustar estado correr/flip solamente si no estamos disparando
		if velocity.x != 0 and is_on_floor():
			current_state = State.correr
			animated_sprite_2d.flip_h = direction < 0

	# --- LUEGO: gravedad (solo si NO estamos en disparo) ---
	if current_state != State.disparo:
		if not is_on_floor():
			velocity += get_gravity() * delta
			# si estamos en el aire y no disparando, estamos en salto
			if current_state != State.disparo:
				current_state = State.salto

	# Aplicar movimiento
	move_and_slide()

	# Actualizar estado idle si corresponde (no pisa disparo)
	jugador_idle()

	# Reproducir animaciones segun estado
	jugador_animacion()


func jugador_idle():
	# No pisar el estado disparo
	if current_state == State.disparo:
		return
	if is_on_floor() and velocity.x == 0:
		current_state = State.idle


func jugador_disparo():
	# Si se presiona disparo y no estamos ya disparando
	if Input.is_action_just_pressed("diparo") and current_state != State.disparo:
		# congelar movimiento horizontal y vertical
		velocity.x = 0
		velocity.y = 0            # <- importantísimo: corta la subida
		print("disparo")
		current_state = State.disparo
		# reproducimos la animación inmediatamente
		animated_sprite_2d.play("disparo")


func jugador_animacion():
	match current_state:
		State.idle:
			animated_sprite_2d.play("default")
		State.correr:
			animated_sprite_2d.play("correr")
		State.salto:
			animated_sprite_2d.play("saltar")
		State.disparo:
			# ya la reproducimos al disparar, pero dejamos aquí por compatibilidad
			if animated_sprite_2d.animation != "disparo":
				animated_sprite_2d.play("disparo")


func _on_animation_finished():
	# cuando termina la animación de disparo → volver a idle (o según contexto)
	if current_state == State.disparo:
		# Al terminar, permitimos que la gravedad y el movimiento vuelvan a aplicarse
		current_state = State.idle
