extends Node

signal gained_coins()
signal level_beaten()
var current_checkpoint : Checkpoint
var player : Player
var deaths = 0
var coins = 0
var paused = false
var pause_menu
var win_screen
var coins_collected_label
var first_load = true
var player_dead = false

@onready var static_camera = get_tree().get_current_scene().get_node("StaticCamera")

func gain_coin():
	coins += 1
	gained_coins.emit()
	
func dash_refresh():
	player.can_dash = true
	
func win():
	level_beaten.emit()
	win_screen.visible = true
	get_tree().paused = true
	
func respawn_player():
	player.collision_layer = 2
	player.collision_mask = 1
	player.visible = true
	deaths += 1
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		
func pause_play():
	paused = !paused
	
	pause_menu.visible = paused
		
func resume():
	get_tree().paused = false
	pause_play()
	
func restart():
	coins = 0
	current_checkpoint = null
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func load_world():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/levelSelect.tscn")
	
func quit():
	get_tree().quit()
	
func change_room(room_position: Vector2, room_size: Vector2) -> void:
	game_manager.static_camera = get_tree().get_current_scene().get_node("StaticCamera")
	static_camera.current_room_center = room_position
	static_camera.current_room_size = room_size

