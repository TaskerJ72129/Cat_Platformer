extends Node
class_name RunTimeLevel

@onready var level_name = name
@onready var ui_manager = $UIManager
@onready var coins_collected_label = $UIManager/WinScreen/Coins_collected


var max_coins = 0

func _ready():
	game_manager.level_beaten.connect(beat_level)
	set_values()

func set_values():
	for node in get_children():
		if node is Coin:
			max_coins += node.coins
			
func beat_level():
	coins_collected_label.text = "Coins collected: " + str(ui_manager.balance) + "/7"
	LevelData.generate_level(LevelData.level_dict[level_name]["unlocks"])
	LevelData.level_dict[LevelData.level_dict[level_name]["unlocks"]]["unlocked"] = true
	
	LevelData.update_level(level_name, ui_manager.balance, max_coins, game_manager.deaths, true)
