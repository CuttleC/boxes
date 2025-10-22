extends Area2D

func enable_sprinkle():
	$CollisionShape2D.disabled = false

func disable_sprinkle():
	$CollisionShape2D.disabled = true

func set_sprite_direction(direction):
	$AnimatedSprite2D.flip_h = direction
