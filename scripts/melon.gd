extends Node2D

@onready var sprite = $Sprite2D
@onready var collision = $Area2D/CollisionShape2D
@onready var timer = $Timer

func _ready():
	if !sprite.visible:
		sprite.visible = true
		collision.set_deferred("disabled", false)
		
func _on_area_2d_area_entered(_area):
	timer.start()
	game_manager.dash_refresh()
	sprite.visible = false
	collision.set_deferred("disabled", true)

func _on_timer_timeout():
	sprite.visible = true
	collision.set_deferred("disabled", false)
