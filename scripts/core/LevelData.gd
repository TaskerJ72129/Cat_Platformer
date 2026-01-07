extends Node

var level_dict = {
	"Level1" : {
		"unlocked" : true,
		"coins" : 0,
		"max_coins" : 0,
		"deaths" : 0,
		"unlocks" : "Level2",
		"beaten" : false
	}
}



func generate_level(level):
	if level not in level_dict:
		level_dict[level] = {
			"unlocked" : false,
			"coins" : 0,
			"max_coins" : 0,
			"deaths" : 0,
			"unlocks" : generate_level_number(level),
			"beaten" : false
		}

func generate_level_number(level):
	var level_number = ""
	for character in level:
		if character.is_valid_int():
			level_number += character
	level_number = int(level_number) + 1
	return "Level" + str(level_number)

func update_level(level, coins, max_coins, deaths, beaten):
	level_dict[level]["coins"] = coins
	level_dict[level]["max_coins"] = max_coins
	level_dict[level]["deaths"] = deaths
	level_dict[level]["beaten"] = beaten
	
