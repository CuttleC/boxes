extends StaticBody2D
signal restored

@export var offers_reward = true
@export var MAX_SATURATION = 100
var current_saturation = 0
var is_restored = false


func _ready():
	$SaturationBar.max_value = MAX_SATURATION
	set_saturation_bar()


func _physics_process(delta):
	if is_restored: return
	
	if $Area2D.get_overlapping_areas().any(is_water):
		current_saturation += 1
	else:
		current_saturation -= 1
	current_saturation = clampi(current_saturation, 0, MAX_SATURATION)
	set_saturation_bar()
	
	if current_saturation == MAX_SATURATION:
		restore_plant()


func is_water(area):
	return area.is_in_group("water")


func restore_plant():
	$AnimatedSprite2D.animation = "restored"
	$SaturationBar.visible = false
	is_restored = true
	restored.emit()
	if offers_reward: offer_reward()


func offer_reward():
	var reward_packed_scene = preload("res://reward.tscn")
	var reward_instance = reward_packed_scene.instantiate()
	reward_instance.position = $RewardMarker.position
	add_child(reward_instance)
	offers_reward = false
	


func set_saturation_bar():
	$SaturationBar.value = current_saturation


#func _on_area_2d_area_entered(area: Area2D) -> void:
#	if area.is_in_group("water"):
#		current_saturation += 10
