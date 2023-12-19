extends Node

@onready var file_reader: FileReader = $FileReader
@export var example_file_path: String
@export var input_file_path: String

func _ready():
	var example_cards: PackedStringArray = file_reader.read_file_as_lines(
		example_file_path)
	_calculate_card_deck_points(example_cards)
	
	var input_cards: PackedStringArray = file_reader.read_file_as_lines(
		input_file_path)
	_calculate_card_deck_points(input_cards)
	
	_calculate_total_scratchcards(example_cards)
	
	_calculate_total_scratchcards(input_cards)
	
func _read_cards(card_deck: PackedStringArray, winning_numbers: Array, 
own_numbers: Array):
	var tmp_split_string: PackedStringArray = []
	var tmp_array: PackedInt32Array = []
	for string in card_deck:
		string = string.erase(0, string.find(":") + 1)
		tmp_split_string = string.split("|")
		
		tmp_array = []
		for winning_number in tmp_split_string[0].split(" "):
			if winning_number.is_valid_int():
				tmp_array.append(winning_number.to_int())
		winning_numbers.append(tmp_array)
				
		tmp_array = []
		for own_number in tmp_split_string[1].split(" "):
			if own_number.is_valid_int():
				tmp_array.append(own_number.to_int())
		own_numbers.append(tmp_array)	
	
func _calculate_card_deck_points(card_deck: PackedStringArray):
	var winning_numbers: Array = []
	var own_numbers: Array = []
	_read_cards(card_deck, winning_numbers, own_numbers)
		
	var card: int = 0
	var tmp_points: int = 0
	var total_points: int = 0
	for numbers in own_numbers:
		tmp_points = 0
		
		for number in numbers:
			if winning_numbers[card].has(number):
				if tmp_points == 0:
					tmp_points += 1
				else:
					tmp_points *= 2
			
		total_points += tmp_points
		card += 1
	
	print(total_points)
	
func _get_winning_numbers_count(winning_numbers: Array, own_numbers: Array):
	var winning_numbers_count: int = 0
	for number in own_numbers:
		if winning_numbers.has(number):
			winning_numbers_count += 1
	
	return winning_numbers_count
	
func _calculate_total_scratchcards(card_deck: PackedStringArray):
	var winning_numbers: Array = []
	var own_numbers: Array = []
	_read_cards(card_deck, winning_numbers, own_numbers)
	
	var card_count_dictionary: Dictionary = {}
	for i in card_deck.size():
		card_count_dictionary[i] = 1
	
	for i in card_count_dictionary.size():
		for j in _get_winning_numbers_count(winning_numbers[i], 
			own_numbers[i]):
			card_count_dictionary[i + j + 1] += card_count_dictionary[i]

	var total_scratchcards: int = 0
	for cards in card_count_dictionary.values():
		total_scratchcards += cards
	
	print(total_scratchcards)
