extends Node2D

@onready var event_card_manager: Node2D = $"../EventCardManager"

var player_hand = []
var center_screen_x 
var card_width: int = 140
var hand_y: int = 900

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 10
@export var x_sep := 20
@export var y_min := 50
@export var y_max := -50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2 
	


func add_card_to_hand(card):
	if card not in player_hand: # se carta nao esta na mao
		player_hand.append(card)
		update_hand_positions()
	else: # se ja estava na mao so anima ela de volta
		animate_card_to_position(card, card.hand_original_pos)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

func update_hand_positions():

	player_hand.sort_custom(sort_by_type)
	for i in range(player_hand.size()):
		#reseting the position of the cards in the loop based on index 
		var new_position = Vector2(calculate_card_position(i), hand_y)
		var card = player_hand[i]
		card.hand_original_pos = new_position
		animate_card_to_position(card, new_position)
	
func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * card_width
	var x_offset = center_screen_x + index * (card_width + 15 ) - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.2)
	
func sort_by_type(a, b):
	return a.card_type < b.card_type
