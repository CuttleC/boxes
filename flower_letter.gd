extends Area2D


func _ready():
	$AnimatedSprite2D.animation = "wilted"


func bloom():
	$AnimatedSprite2D.animation = "restored"
