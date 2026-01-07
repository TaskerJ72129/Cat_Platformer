extends CharacterBody2D
class_name Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 110
const JUMP_VELOCITY = -250
const WALL_SLIDE_SPEED = 60
@export var wall_jump_pushback = 250
@export var wall_jump_pushup = -250

const DASH_SPEED = 200
const DASH_LENGTH = .15

var is_wall_sliding = false
var can_dash := true
var dashing_upwards := false
var is_dashing := false
var dash_direction : Vector2
var can_jump := true
@export var jump_buffer_time := 5
var jump_buffer_counter := 0
@export var coyote_time : int = 5
var coyote_counter : int = 0

# climbing
var is_climbing = false
var climb_speed = 100.0

@onready var dash_particles = $dash_particles
@onready var dash_timer = $dash_timer
var dash_sprite = preload("res://scenes/dash_sprite.tscn")

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	game_manager.deaths = 0
	game_manager.player = self
	
func _on_dash_timer_timeout():
	if dashing_upwards:
		velocity.y -= 100
	is_dashing = false
	#if is_on_floor():
		#is_dashing = false
		
	#if is_on_wall():
		#is_dashing = false
	
func get_direction():
	var move_direction = Vector2()
	move_direction.x = -Input.get_action_strength("left") + Input.get_action_strength("right")
	move_direction.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	if move_direction.y > 0:
		dashing_upwards = true
	else:
		dashing_upwards = false
	
	# if no direction pressed
	if (move_direction == Vector2(0,0)):
		if animated_sprite.flip_h:
			move_direction.x = -1
		else:
			move_direction.x = 1
			
	return move_direction * DASH_SPEED
	
func handle_dash(_delta):
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		is_dashing = true
		dash_direction = get_direction()
		dash_timer.start(DASH_LENGTH)
	
	if is_dashing:
		var dash_node = dash_sprite.instantiate()
		dash_node.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
		dash_node.global_position = global_position
		dash_node.flip_h = animated_sprite.flip_h
		get_parent().add_child(dash_node)
		
		#if is_on_wall():
			#is_wall_sliding = false
		
		dash_particles.emitting = true
			
	else:
		dash_particles.emitting = false
		
func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_SPEED * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
		
func climb_handler(_delta):
	if is_on_wall() and Input.is_action_pressed("climb"):
		velocity.y = 0
		is_climbing = true
		# gravity = 0
	else:
		is_climbing = false
		# gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	if is_climbing:
		if is_on_wall() and Input.is_action_pressed("up"):
			velocity.y = -climb_speed  # Move up while climbing
		elif is_on_wall() and Input.is_action_pressed("down"):
			velocity.y = climb_speed  # Move down while climbing

	
func _physics_process(delta):
	if game_manager.player_dead:
		velocity.y = 0
		velocity.x = 0
	
	# Add the gravity.
	if not is_on_floor():
		if coyote_counter > 0:
			coyote_counter -= 1
		velocity.y += gravity * delta
	
	if is_on_floor():
		coyote_counter = coyote_time
		can_dash = true

		
	#climb_handler(delta)
	
	if is_on_wall() and (Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left")):
		can_jump = true
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.4
	
	# dash
	if game_manager.player_dead == false:
		handle_dash(delta)
	
	# wall slide
	wall_slide(delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_counter = 0
		coyote_counter = 0
		
	# Get the input direction 1, 0, -1
	var direction = Input.get_axis("left", "right")
	# flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	# play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			if is_climbing:
				animated_sprite.play("climb")
			else:
				animated_sprite.play("jump")
		elif velocity.y > 0:
			if is_climbing:
				animated_sprite.play("climb")
			else:
				animated_sprite.play("fall")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		
	if jump_buffer_counter > 0 and is_on_wall():
		jump_buffer_counter = 0
		if animated_sprite.flip_h == false:
			velocity.x = -wall_jump_pushback
			velocity.y = JUMP_VELOCITY 
			move_and_slide()
			animated_sprite.flip_h = true
		elif animated_sprite.flip_h == true:
			velocity.x = wall_jump_pushback
			velocity.y = JUMP_VELOCITY
			move_and_slide()
			animated_sprite.flip_h = false
	
	if(is_dashing):
		velocity.x += dash_direction[0]
		velocity.y -= dash_direction[1]
		move_and_slide()
		velocity.x = 0
		velocity.y = 0
	else:
		move_and_slide()
	
	
func _on_room_detector_area_entered(area):
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size: Vector2 = collision_shape.shape.extents * 2
	
	game_manager.change_room(collision_shape.global_position, size)
	
	

	
