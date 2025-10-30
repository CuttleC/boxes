extends Area2D

var is_restored = false


func _ready():
	$AnimatedSprite2D.animation = "wilted"


func _physics_process(delta):
	if is_restored: return
	
	if get_overlapping_areas().any(is_water):
		$AnimatedSprite2D.animation = "restored"
		is_restored = true


func is_water(area):
	return area.is_in_group("water")
