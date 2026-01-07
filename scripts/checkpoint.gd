extends Node2D
class_name Checkpoint

@export var spawnpoint = false
@onready var animated_sprite = $AnimatedSprite2D
@export var win_condition = false

var activated = false

func _ready():
	if spawnpoint:
		activate()
	
func activate():
	if win_condition:
		game_manager.win()
	game_manager.current_checkpoint = self
	activated = true
	animated_sprite.play("flag_get")
	
func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated:
		activate()


func _on_animated_sprite_2d_animation_finished():
	animated_sprite.play("flag_idle")
