extends AnimatedSprite2D

func _ready() -> void:
	# Si la animación no está en autoplay, la arrancás acá
	play()


func _on_timer_timeout() -> void:
	queue_free()
