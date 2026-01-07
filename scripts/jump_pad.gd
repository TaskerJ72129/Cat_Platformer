extends Node2D

@export var force = -400

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and game_manager.player_dead == false:
		$AnimatedSprite2D.play("launch")
		area.get_parent().can_dash = true
		area.get_parent().velocity.y = force
