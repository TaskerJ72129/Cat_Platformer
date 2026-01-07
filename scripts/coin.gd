extends Area2D
class_name Coin

@export var coins = 1

#@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	game_manager.gain_coin()
	animation_player.play("pickup")
