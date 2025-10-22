extends CharacterBody2D
signal hit

@export var speed = 400
var screen_size
@export var water: Area2D
var MAX_WATER = 1000
var water_quantity = 1000


func _ready():
	screen_size = get_viewport_rect().size
	$WaterBar.max_value = MAX_WATER


func _physics_process(delta):
	var temp_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		temp_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		temp_velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		temp_velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		temp_velocity.y += 1
	
	water_plants()
	
	if temp_velocity.length() > 0:
		temp_velocity = temp_velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if temp_velocity.x != 0 || temp_velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = temp_velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"

	#position += velocity * delta
	velocity = temp_velocity
	move_and_slide()
	
	if water == null: return
	
	var direction = 1
	if $AnimatedSprite2D.flip_h: direction = -1
	water.set_sprite_direction($AnimatedSprite2D.flip_h)
	var water_offset = 96 * direction
	water.position.x = water_offset


func water_plants():
	if water == null:
		return
	if Input.is_action_pressed("water") && water_quantity > 0:
		water_quantity -= 1
		water.show()
		water.enable_sprinkle()
		set_water_bar()
	else:
		water.hide()
		water.disable_sprinkle()


func set_water_bar():
	$WaterBar.value = water_quantity


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
