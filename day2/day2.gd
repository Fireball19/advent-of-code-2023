extends Node

@onready var file_reader: FileReader = $FileReader
@export var example_file_path: String
@export var input_file_path: String

var bag: Dictionary = {
	"red": 12,
	"green": 13,
	"blue": 14
}

func _ready():
	var example_games: PackedStringArray = file_reader.read_file_as_lines(
		example_file_path)
	_calculate_score_game_id(example_games)
	
	var input_games: PackedStringArray = file_reader.read_file_as_lines(
	input_file_path)
	_calculate_score_game_id(input_games)
	
	_calculate_score_power_cubes(example_games)
	
	_calculate_score_power_cubes(input_games)
	
func _prepare_cube_sets(game: String):
	game = game.substr(game.find(":") + 1, -1)
	var cube_sets = game.split(";")
	
	var tmp_index: int = 0
	for cube_set in cube_sets:
		cube_sets[tmp_index] = cube_set.replace(",", "")
		tmp_index += 1
		
	return cube_sets
	
func _is_game_possible(game: String):
	var cube_sets = _prepare_cube_sets(game)
	
	var tmp_bag: Dictionary = {
		"red": 0,
		"green": 0,
		"blue": 0
	}
	for cube_set in cube_sets:
		var strings = cube_set.split(" ", false)
		
		# reset tmp_bag
		for cube in tmp_bag.keys():
			tmp_bag[cube] = 0
		
		var tmp_int: int = 0
		var i: int = 0
		while i < len(strings):
			if strings[i].is_valid_int():
				tmp_int = strings[i].to_int()
			tmp_bag[strings[i + 1]] = tmp_int
			i += 2
			
		for cube in tmp_bag.keys():
			if tmp_bag[cube] > bag[cube]:
				return false
	
	return true

func _calculate_score_game_id(games: PackedStringArray):
	var score: int = 0
	
	var game_id = 1
	for game in games:
		if _is_game_possible(game):
			score += game_id
		game_id += 1
		
	print(score)
	
func _find_fewest_number_of_cubes(game: String):
	var cube_sets = _prepare_cube_sets(game)
	
	var fewest_bag: Dictionary = {
		"red": 0,
		"green": 0,
		"blue": 0
	}
	for cube_set in cube_sets:
		var strings = cube_set.split(" ", false)
		
		var tmp_int: int = 0
		var i: int = 0
		while i < len(strings):
			if strings[i].is_valid_int():
				tmp_int = strings[i].to_int()
			if 	fewest_bag[strings[i + 1]] < tmp_int:
				fewest_bag[strings[i + 1]] = tmp_int
			i += 2
	
	return fewest_bag
	
func _calculate_score_power_cubes(games: PackedStringArray):
	var score: int = 0
	
	var tmp_bag: Dictionary = {
		"red": 0,
		"green": 0,
		"blue": 0
	}
	for game in games:
		tmp_bag = _find_fewest_number_of_cubes(game)
		score += (tmp_bag["red"] * tmp_bag["green"] * tmp_bag["blue"])
	
	print(score)
