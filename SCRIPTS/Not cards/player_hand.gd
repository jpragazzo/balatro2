extends Node2D

@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var debug_label: Label = %DebugLabel

var player_hand = []
var center_screen_x 
var card_width: int = 140
var hand_y: int = 900
@onready var size = $Area2D/CollisionShape2D.shape.get_rect().size

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 10
@export var x_sep := 20
@export var y_min := 50
@export var y_max := -150

var mouse_hovering = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2 

func _process(delta: float) -> void:
	
	var close_card = get_card_close_to_mouse()
	
	
	

func get_card_close_to_mouse():
	#print("get_card") OK
	
	if player_hand.size() == 0:
		return
	
	#print("get_card") OK
	
	var mouse_pos = get_global_mouse_position() #vector2
	var max_distance = 100 #minimum distance for starting hovering
	var current_distance = 0
	var close_cards = []
	var card_hovered 
	var closest_card = null
	var min_dist = null
	#print("get_card") OK

	for card in player_hand: #cicla adicionando ou removendo as cartas proximas
		var distance = mouse_pos.distance_to(card.global_position)
		if distance < max_distance: # se estiver perto
			if !close_cards.has(card): # e a carta nn tiver ainda ele coloca
				close_cards.append(card)
		else: 						# se estiver longe
			if close_cards.has(card): # e estiver, ele tira
				close_cards.pop_at(close_cards.find(card)) 
	
	
	if close_cards.size() == 0: #já checou as perto, se não tem, não tem
		return
	
	if close_cards.size() == 1: # Se ta PERTO e so tem UMA, é ela que o mouse ta hovering
		card_hovered = close_cards[0]
		closest_card = card_hovered
		print("1")
		return closest_card
	else:					# Se ta PERTO e tem >2
		for closecard in close_cards: 
			print("2")
			if min_dist == null: #se for a primeira vez que a função roda
				min_dist = mouse_pos.distance_to(closecard.global_position)
				closest_card = closecard #assume o papel de mais próxima
			else: #se já for a segunda detectada em diante e se a distancia for menor que a primeira ou anterior
				if mouse_pos.distance_to(closecard.global_position) < min_dist:
					min_dist = mouse_pos.distance_to(closecard.global_position)
					closest_card = closecard
	
	if closest_card == null:
		print("null")
	return closest_card

func add_card_to_hand(card):
	if card not in player_hand: # se carta nao esta na mao
		player_hand.append(card)
		update_hand_positions()
	else: # se ja estava na mao so anima ela de volta
		update_hand_positions()
		animate_card_to_position(card, card.hand_original_pos)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

func update_hand_positions():
	var total_cards = player_hand.size()
	var all_cards_size = (card_width * total_cards) + (x_sep * total_cards)
	var final_x_sep = x_sep

	player_hand.sort_custom(sort_by_type)
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - card_width * total_cards) / (total_cards - 1)
		all_cards_size = size.x
	
	var offset = (size.x - all_cards_size) / 2
	
	if offset == 0:
		offset = offset - 12
	
	for i in total_cards:
		
		var y_multiplier := hand_curve.sample(1.0 / (total_cards-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (total_cards-1) * i)
		
		if total_cards == 1:
			y_multiplier = 0.4
			rot_multiplier = 0.0
		
		var final_pos_x = (offset + card_width * i + final_x_sep * i) + 510
		var final_y_variation: float = y_min + y_max * y_multiplier
		var final_pos_y = hand_y + final_y_variation
		
		#reseting the position of the cards in the loop based on index 
		var new_position = Vector2(final_pos_x, final_pos_y)
		var new_rotation = max_rotation_degrees * rot_multiplier
		
		var card = player_hand[i]

		card.hand_original_pos = new_position
		
		animate_card_to_position(card, new_position)
		spin_card(card, new_rotation)
		set_card_z_index(card, i)
	
#func calculate_card_x(index):
#
	#var x_offset = (card_width * index)
	#return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(card, "position", new_position, 0.2)

func spin_card(card, new_rotation):
	var tween2 = get_tree().create_tween()
	tween2.tween_property(card, "rotation_degrees", new_rotation, 0.2)
	
func set_card_z_index(card, i):
	card.z_index = 50 + i
	
func sort_by_type(a, b):
	return a.card_type < b.card_type


func _on_hover_area_mouse_entered() -> void:
	mouse_hovering = true

func _on_hover_area_mouse_exited() -> void:
	mouse_hovering = false 
