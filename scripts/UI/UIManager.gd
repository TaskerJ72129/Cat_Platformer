extends CanvasLayer
class_name UIManager

@onready var coin_amount = $CoinAmount
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var count_down = %CountDown
@onready var level_time_label = %LevelTimeLabel
@onready var level_complete_time = %levelCompleteTime
@onready var coins_collected = %Coins_collected
@onready var coin_holder = %CoinHolder
@onready var deaths = %Deaths

var can_pause = true
var coins_total = 0
var freeze_time = 0.0
var level_time = 0.0
var time_when_paused = 0.0
var time_when_unpaused = 0.0
var pause_time = 0.0

func _ready():
	game_manager.pause_menu = $PauseMenu
	game_manager.win_screen = $WinScreen
	game_manager.coins_collected_label = $WinScreen/Coins_collected
	game_manager.gained_coins.connect(update_coin_display)
	game_manager.level_beaten.connect(update_level_complete_display)
	level_time = 0.0
	level_time_label.visible = false
	can_pause = false
	get_tree().paused = true
	count_down.play("countdown")
	await count_down.animation_finished
	get_tree().paused = false
	freeze_time = Time.get_ticks_msec()
	level_time_label.visible = true
	can_pause = true
	
func _process(_delta):
	if !game_manager.paused:
		level_time = Time.get_ticks_msec() - freeze_time - pause_time
	level_time_label.text = str(level_time/1000.0)
	if Input.is_action_just_pressed("pause") and can_pause:
		pause_pressed()
		game_manager.pause_play()
		get_tree().paused = game_manager.paused
		
func pause_pressed():
	if !game_manager.paused:
		time_when_paused = Time.get_ticks_msec()
	else:
		time_when_unpaused = Time.get_ticks_msec()
		pause_time += time_when_unpaused - time_when_paused

func update_coin_display():
	coins_total += 1
	coin_amount.text = str(coins_total)
	
func update_level_complete_display():
	
	level_time_label.visible = false
	can_pause = false
	level_complete_time.text = "Time: "+str(level_time/1000.0)
	coins_collected.text = "Coins: "+str(coins_total)+"/"+str(coin_holder.get_child_count()+coins_total)
	deaths.text = "Deaths: "+str(game_manager.deaths)
	

func _on_resume_pressed():
	game_manager.resume()

func _on_restart_pressed():
	game_manager.paused = false
	game_manager.restart()

func _on_world_map_pressed():
	game_manager.load_world()

func _on_quit_pressed():
	game_manager.quit()

func _on_finish_level_pressed():
	game_manager.load_world()

