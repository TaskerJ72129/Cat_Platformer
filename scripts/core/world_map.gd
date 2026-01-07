extends Node2D

@onready var level_holder = $LevelHolder
@onready var player = $Player

var levels = []
@onready var curr_level = $LevelHolder/Level1

var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1

func _ready():
	player.play("idle")
	levels = level_holder.get_children()
	update_levels()
	
func update_levels():
	for level in levels:
		if level.name in LevelData.level_dict:
			if LevelData.level_dict[level.name]["unlocked"] == true:
				level.get_node("Sprite2D").visible = false

func _process(delta):
	var target_level : Node2D
	
	if Input.is_action_pressed("up"):
		if curr_level.up:
			target_level = curr_level.up
	if Input.is_action_pressed("down"):
		if curr_level.down:
			target_level = curr_level.down
	if Input.is_action_pressed("left"):
		if curr_level.left:
			target_level = curr_level.left
	if Input.is_action_pressed("right"):
		if curr_level.right:
			target_level = curr_level.right
	if Input.is_action_pressed("jump"):
		player.play("jump")
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://scenes/World/" + curr_level.name + ".tscn")
			
	if target_level and target_level.name in LevelData.level_dict and LevelData.level_dict[target_level.name]["unlocked"] and completed_movement:
		completed_movement = false
		player.play("run")
		lerp_progress = 0.0
		while lerp_progress < 1.0:
			lerp_progress += lerp_speed + delta
			lerp_progress = clamp(lerp_progress, 0.0, 1.0)
			player.position = player.position.lerp(target_level.global_position, lerp_progress)
			
			if player.position.distance_to(target_level.global_position) < lerp_threshold:
				break
				
			await get_tree().create_timer(delta).timeout
		player.position = target_level.global_position
		curr_level = target_level
		player.play("idle")
		completed_movement = true
			
