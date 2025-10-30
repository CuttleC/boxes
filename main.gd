extends Node
var flower_letters: Array
var plant_objectives: Array
var blooming = false
var time_for_another_flower_to_bloom = true
var camera_in_place = true

func _ready():
	$TileMapLayer/Player.start($TileMapLayer/StartPosition.position)
	flower_letters = get_tree().get_nodes_in_group("flower_letter")
	flower_letters.shuffle()
	plant_objectives = get_tree().get_nodes_in_group("plant_objective")


func _process(delta):
	if !camera_in_place: return
	if !blooming: return
	if !time_for_another_flower_to_bloom: return
	
	var next_flower_letter = flower_letters.pop_front()
	if next_flower_letter != null: next_flower_letter.bloom()
	time_for_another_flower_to_bloom = false
	$Timer.start()
	
	#TODO: make the camera move to see all the flower letters
	#TODO: make all the final pixel art (sal_walking, big plants withered and restored, small plants withered and restored, well, wall, flower letters, grass ground background, reward icon, water spray, fun plants)
	#TODO: design overall level


func are_all_plants_restored():
	for plant in plant_objectives:
		if !plant.is_restored:
			return false
	return true


func _on_timer_timeout() -> void:
	time_for_another_flower_to_bloom = true


func _on_plant_restored() -> void:
	if are_all_plants_restored():
		blooming = true
		$Timer.start()
		activate_cutscene_camera()


func activate_cutscene_camera():
	$CutsceneCam.position = $TileMapLayer/Player/Camera2D.position
	
	
