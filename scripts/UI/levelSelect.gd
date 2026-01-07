extends Control


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_level_1_pressed():
	game_manager.paused = false
	get_tree().change_scene_to_file("res://scenes/World/Level1.tscn")
