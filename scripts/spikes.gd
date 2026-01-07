extends Node2D

@onready var timer = $Timer

func _on_area_2d_area_entered(area):
		if area.get_parent() is Player:
			if game_manager.player_dead == false:
				game_manager.player_dead = true
				timer.start()
				area.get_parent().collision_layer = 16
				area.get_parent().collision_mask = 16
				area.get_parent().velocity.x = 0
				area.get_parent().velocity.y = 0
				area.get_parent().visible = false
			

func _on_timer_timeout():
	game_manager.player_dead = false
	game_manager.respawn_player()
