extends Area2D


func _ready():
	$AnimatedSprite2D.play("level_1")

func enable_sprinkle():
	$CollisionShape2D.disabled = false

func disable_sprinkle():
	$CollisionShape2D.disabled = true

func set_sprite_direction(direction):
	$AnimatedSprite2D.flip_h = direction
