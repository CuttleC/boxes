extends Camera2D

@export var target: Marker2D
var moving = false
const FOLLOW_SPEED = 1

func _physics_process(delta):
	if moving && target != null:
		position = position.lerp(target.position, delta * FOLLOW_SPEED)


func move_to_target():
	moving = true
