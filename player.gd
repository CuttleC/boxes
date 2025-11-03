extends CharacterBody2D

@export var speed = 400
@export var water: Area2D
var MAX_WATER = 100
var water_quantity = MAX_WATER
var water_graphics = ["level_2","level_3","level_4","level_5"]


func _ready():
	set_water_bar()
	$Camera2D.make_current()
	$AnimatedSprite2D.play("idle")


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
	
	if temp_velocity.length() > 0:
		temp_velocity = temp_velocity.normalized() * speed
	
	if temp_velocity.x != 0 || temp_velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = temp_velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"

	velocity = temp_velocity
	move_and_slide()
	
	if water == null: return
	
	var direction = 1
	if $AnimatedSprite2D.flip_h: direction = -1
	water.set_sprite_direction($AnimatedSprite2D.flip_h)
	var water_offset = 96 * direction
	water.position.x = water_offset
	water_plants()


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
	water_quantity = clamp(water_quantity, 0, MAX_WATER)


func set_water_bar():
	$WaterBar.max_value = MAX_WATER
	$WaterBar.value = water_quantity


func get_rewarded(reward):
	MAX_WATER += reward
	water_quantity += reward
	set_water_bar()
	if !water_graphics.is_empty():
		$Water/AnimatedSprite2D.animation = water_graphics.pop_front()


func start(pos):
	position = pos
	show()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("well"):
		water_quantity = MAX_WATER
		set_water_bar()
	elif area.is_in_group("reward"):
		get_rewarded(50)
