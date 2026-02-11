extends Node2D

var event_active: bool
var global_event_card 
var global_event_options_number: int = 0
var global_event_option_cliked: int = 0
var is_event_open: int = 0 #0 or 1
var current_score := 0

@onready var event_deck: Node2D = $"../EventDeck"
@onready var slot_manager: Node2D = $"../SlotManager"
@onready var control: Control = $"../Control"
@onready var card_manager: Node2D = $"../CardManager"
@onready var deck: Node2D = $"../Deck"
@onready var player_hand: Node2D = $"../PlayerHand"


const CARD = preload("res://scenes/Card.tscn")

func start_event(event_card): #chamada no event_deck quando clica na area do deck
	global_event_card = event_card
	#control.deactivate_options_area()
	global_event_options_number = global_event_card.resource.options.number_of_options.size()
	match_options_descriptions()
	#await event_req_card_check()
	#event_requisites_write(event_card) #COMENTING BECAUSE WE HAVE ICONS NOW
	lock_current_event()
	enable_skip()
	match_icon()
	#show_icons()
#func end_event(event_card)

func get_event_requisites_cards(): #returns an array of the 3 arrays containing the event requisites
	
	var event_requisites_cards_array1: Array[String]
	var event_requisites_cards_array2: Array[String]
	var event_requisites_cards_array3: Array[String]
	
	if global_event_card.resource.RequisitesAndRewards1["requisites"]["cards"].size() != 0:
		global_event_options_number += 1
		for i in global_event_card.resource.RequisitesAndRewards1["requisites"]["cards"]:
			event_requisites_cards_array1.append(i)
			print(i)
	if global_event_card.resource.RequisitesAndRewards2["requisites"]["cards"].size() != 0:
		global_event_options_number += 1
		for i in global_event_card.resource.RequisitesAndRewards2["requisites"]["cards"]:
			event_requisites_cards_array2.append(i)
			print(i)
	if global_event_card.resource.RequisitesAndRewards3["requisites"]["cards"].size() != 0:
		global_event_options_number += 1
		for i in global_event_card.resource.RequisitesAndRewards3["requisites"]["cards"]:
			event_requisites_cards_array3.append(i)
			print(i)
			
		
	var big_array = [event_requisites_cards_array1, event_requisites_cards_array2, event_requisites_cards_array3]
	print(big_array)
	return big_array

#func get_event_requisites_events(global_event_card):
	#if global_event_card.resource.RequisitesAndRewards["requisites"]["events"].size() != 0:
		#var event_requisites_events_array: Array[String]
		#for j in global_event_card.resource.RequisitesAndRewards["requisites"]["events"]:
			#event_requisites_events_array.append(" (" + j + ") ")
		#return event_requisites_events_array
	#else: 
		#return []
func get_event_rewards_cards():
	
	var event_rewards_cards_array1: Array[String]
	var event_rewards_cards_array2: Array[String]
	var event_rewards_cards_array3: Array[String]
	
	if global_event_card.resource.RequisitesAndRewards1["rewards"]["cards"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards1["rewards"]["cards"]:
			event_rewards_cards_array1.append(i)
	if global_event_card.resource.RequisitesAndRewards2["rewards"]["cards"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards2["rewards"]["cards"]:
			event_rewards_cards_array2.append(i)
	if global_event_card.resource.RequisitesAndRewards3["rewards"]["cards"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards3["rewards"]["cards"]:
			event_rewards_cards_array3.append(i)
			
	var big_array = [event_rewards_cards_array1, event_rewards_cards_array2, event_rewards_cards_array3]
	return big_array

func get_event_rewards_events():
	var event_rewards_events_array1: Array[String]
	var event_rewards_events_array2: Array[String]
	var event_rewards_events_array3: Array[String]
	
	if global_event_card.resource.RequisitesAndRewards1["rewards"]["events"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards1["rewards"]["events"]:
			event_rewards_events_array1.append(i)
	if global_event_card.resource.RequisitesAndRewards2["rewards"]["events"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards2["rewards"]["events"]:
			event_rewards_events_array2.append(i)
	if global_event_card.resource.RequisitesAndRewards3["rewards"]["events"].size() != 0:
		for i in global_event_card.resource.RequisitesAndRewards3["rewards"]["events"]:
			event_rewards_events_array3.append(i)
			
	var big_array = [event_rewards_events_array1, event_rewards_events_array2, event_rewards_events_array3]
	return big_array

#func event_requisites_write(event_card): #WRITE REQUISITES ON CARD
	#
	#var erc = get_event_requisites_cards(event_card)
	#var ere = get_event_requisites_events(event_card)  
	#var erc2 = get_event_rewards_cards(event_card)
	#var ere2 = get_event_rewards_events(event_card)  
	#
	#for card in erc:
		#event_card.get_node("EventRequisites").text += card
	#for card in ere:
		#event_card.get_node("EventRequisites").text += card
	#for card in erc2:
		#event_card.get_node("EventRewards").text += card
	#for card in ere2:
		#event_card.get_node("EventRewards").text += card
#func event_rewards_write(event_card): #WRITE REWARDS ON CARD
	#var reqsandrew = event_card.resource.RequisitesAndRewards
	#
	#
	#
	#if reqsandrew["rewards"]["cards"].size() != 0 or reqsandrew["rewards"]["events"].size() != 0:
		#for i in reqsandrew["rewards"]["cards"]:
			#event_card.get_node("EventRewards").text += " (" + i + ") "
		#for j in reqsandrew["rewards"]["events"]:
			#event_card.get_node("EventRewards").text += " (" + j + ") "
	#else:
		#print('wutuheeeeell') 

func lock_current_event():
	event_active = true #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = true
func unlock_current_event():
	event_active = false #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = false
	
func score():
	current_score += 1
	control.current_score_number.text = str(current_score)
	
	if int(control.current_score_number.text) >= int(control.high_score_number.text):
		control.high_score_number.text = control.current_score_number.text
		control.save(int(control.current_score_number.text))
	
func event_req_card_check():
	var array_of_cards_to_destroy: Array[Node2D] = []
	var array_of_slots_to_free: Array[Node2D] = []
	var slots_with_cards: Array[String] = []
	var slot_number := 1
	
	var requisites
	
	
	# -----------------------------------------
	# 0. Verifica se há evento ativo
	# -----------------------------------------
	print(global_event_option_cliked)
	if global_event_card != null:
		requisites = get_event_requisites_cards()
	else:
		control.error_message("No event active at this moment!")
		return -1

	# -----------------------------------------
	# 1. Coleta requisitos do evento
	# -----------------------------------------
	
	if requisites[(global_event_option_cliked - 1)].is_empty(): #if there are NO options with requisites
		event_rew_card_give()
		return 0

	# -----------------------------------------
	# 2. Coleta slots com cartas
	# -----------------------------------------
	for i in 3:
		var slot_path = "SlotMiddle" + str(slot_number)
		var slot = slot_manager.get_node(slot_path)

		if slot.card_in_slot != null:
			slots_with_cards.append(slot_path)

		slot_number += 1

	if slots_with_cards.size() < requisites[global_event_option_cliked].size():
		control.error_message("Not enough cards!")
		return 0

	# -----------------------------------------
	# 3. Agrupa cartas por tipo (ENUM)
	# -----------------------------------------
	var cards_by_type := {
		Card.CardType.MONSTER: [],
		Card.CardType.ARMOR: [],
		Card.CardType.WEAPON: [],
		Card.CardType.CONSUMABLE: [],
		Card.CardType.GENERIC: [],  # cartas realmente genéricas, se existirem
		Card.CardType.MONEY: [],
		Card.CardType.BADLUCK: []
	}

	for slot_path in slots_with_cards:
		var slot = slot_manager.get_node(slot_path)
		var card = slot.card_in_slot
		var type = card.card_type
		cards_by_type[type].append({"card": card, "slot": slot})

	# -----------------------------------------
	# 4. Conta requisitos por tipo (ENUM)
	# -----------------------------------------
	var req_count := {
		Card.CardType.MONSTER: 0,
		Card.CardType.ARMOR: 0,
		Card.CardType.WEAPON: 0,
		Card.CardType.CONSUMABLE: 0,
		Card.CardType.GENERIC: 0,
		Card.CardType.MONEY: 0,
		Card.CardType.BADLUCK: 0
	}

	for req in requisites[global_event_option_cliked]:
		var type = letter_to_type(req, null)
		if type == null:
			control.error_message("Invalid requisite: " + str(req))
			return 0
		req_count[type] += 1

	# -----------------------------------------
	# 5. Verifica se há cartas suficientes para requisitos específicos
	# -----------------------------------------
	for type in [Card.CardType.MONSTER, Card.CardType.ARMOR, Card.CardType.WEAPON, Card.CardType.CONSUMABLE]:
		if cards_by_type[type].size() < req_count[type]:
			control.error_message("Event requisites not met!")
			return 0

	# -----------------------------------------
	# 6. Seleciona cartas específicas primeiro
	# -----------------------------------------
	for type in [Card.CardType.MONSTER, Card.CardType.ARMOR, Card.CardType.WEAPON, Card.CardType.CONSUMABLE]:
		for i in req_count[type]:
			var entry = cards_by_type[type].pop_front()
			array_of_cards_to_destroy.append(entry["card"])
			array_of_slots_to_free.append(entry["slot"])
			entry["slot"].card_in_slot = null

	# -----------------------------------------
	# 7. Agora trata os genéricos (pega qualquer carta restante)
	# -----------------------------------------
	var generic_needed = req_count[Card.CardType.GENERIC]

	# Junta todas as cartas restantes
	var remaining_cards := []
	for type in cards_by_type.keys():
		remaining_cards += cards_by_type[type]

	if remaining_cards.size() < generic_needed:
		control.error_message("Event requisites not met!")
		return 0

	for i in generic_needed:
		var entry = remaining_cards.pop_front()
		array_of_cards_to_destroy.append(entry["card"])
		array_of_slots_to_free.append(entry["slot"])
		entry["slot"].card_in_slot = null

	# -----------------------------------------
	# 8. Anima, recompensa e finaliza evento
	# -----------------------------------------
	animate_cards(array_of_cards_to_destroy, array_of_slots_to_free)
	
	event_rew_card_give()

	return 1

func letter_to_type(letter, _unused):
	letter = letter.strip_edges()

	match letter:
		"(c)": return Card.CardType.CONSUMABLE #0
		"(a)": return Card.CardType.ARMOR #1
		"(w)": return Card.CardType.WEAPON #2
		"(m)": return Card.CardType.MONSTER #3
		"(g)": return Card.CardType.GENERIC #4
		"($)": return Card.CardType.MONEY #5
		"(b)": return Card.CardType.BADLUCK #6

	push_warning("Requisite inválido: " + str(letter))
	return null
	
func match_options_descriptions():
	var left_label = global_event_card.get_node("Left/EventChoise1")
	var center_label = global_event_card.get_node("Center/EventChoise2")
	var right_label = global_event_card.get_node("Right/EventChoise3")
	
	match global_event_options_number:
		1:
			left_label.text = ""
			center_label.text = global_event_card.resource.options.number_of_options[0]
			right_label.text = ""
		2:
			left_label.text = global_event_card.resource.options.number_of_options[0]
			center_label.text = ""
			right_label.text = global_event_card.resource.options.number_of_options[1]
		3:
			left_label.text = global_event_card.resource.options.number_of_options[0]
			center_label.text = global_event_card.resource.options.number_of_options[1]
			right_label.text = global_event_card.resource.options.number_of_options[2]
	

func match_icon(): #STILL NEED EVENT PART
	var reqsandrew
	var option_name := "center"
	match global_event_option_cliked:
		1:
			option_name = "Left"
			reqsandrew = global_event_card.resource.RequisitesAndRewards1
		2:
			option_name = "Center"
			reqsandrew = global_event_card.resource.RequisitesAndRewards2
		3:
			option_name = "Right"
			reqsandrew = global_event_card.resource.RequisitesAndRewards3
			
	
	for u in global_event_card.get_node(option_name +"/RequisitesSprites").get_children().size():
		global_event_card.get_node(option_name +"/RequisitesSprites").get_child(u).visible = true
		global_event_card.get_node(option_name +"/RequisitesSprites").get_child(u).set_animation("empty")
		global_event_card.get_node(option_name +"/RewardsSprites").get_child(u).visible = true
		global_event_card.get_node(option_name +"/RewardsSprites").get_child(u).set_animation("empty")
	
	if reqsandrew["requisites"]["cards"].size() != 0 or reqsandrew["requisites"]["events"].size() != 0:
		for k in reqsandrew["requisites"]["cards"].size():
			var card_letter = reqsandrew["requisites"]["cards"][k]
			global_event_card.get_node(option_name +"/RequisitesSprites").get_children()[k].set_animation(return_animation_name_from_letter(card_letter))
		#for j in reqsandrew["requisites"]["events"].size():
			#var event_letter = reqsandrew["requisites"]["events"][j]
			#global_event_card.get_node("RequisitesSprites").get_children()[j].set_animation(return_animation_name_from_letter(event_letter))
	if reqsandrew["rewards"]["cards"].size() != 0 or reqsandrew["rewards"]["events"].size() != 0:
		for j in reqsandrew["rewards"]["cards"].size():
			var card_letter = reqsandrew["rewards"]["cards"][j]
			global_event_card.get_node(option_name +"/RewardsSprites").get_children()[j].set_animation(return_animation_name_from_letter(card_letter))
		#for j in reqsandrew["rewards"]["events"].size():
			#var event_letter = reqsandrew["rewards"]["events"][j]
			#global_event_card.get_node("RewardsSprites").get_children()[j].set_animation(return_animation_name_from_letter(event_letter))
	#else:
		#print(reqsandrew["rewards"]["cards"].size())
		#print(reqsandrew["rewards"]["events"].size())
		#print('wutuheeeeell2') 
func show_icons(): #STILL NEED EVENT PART
	var reqsandrew = global_event_card.resource.RequisitesAndRewards

	if reqsandrew["requisites"]["cards"].size() != 0 or reqsandrew["requisites"]["events"].size() != 0:
		for i in reqsandrew["requisites"]["cards"].size():
			var card_letter = reqsandrew["requisites"]["cards"][i]
			global_event_card.get_node("RequisitesSprites").get_child(i).visible = true
		for j in reqsandrew["requisites"]["events"]:
			var card_letter = reqsandrew["rewards"]["cards"][j]
			global_event_card.get_node("RewardsSprites").get_child(j).visible = true

func return_animation_name_from_letter(card_letter) -> String:
	match card_letter:
		"w":
			return "weapon"
		"c":
			return "consumable"
		"m":
			return "monster"
		"$":
			return "money"
		"b":
			return "badluck"
		"a":
			return "armor"
		"g":
			return "generic"
		_:
			return "invalid"


func event_rew_card_give() -> void:
	var reqandrew
	var rewards: PackedStringArray = []
	
	
	match global_event_option_cliked:
		1:
			reqandrew = global_event_card.resource.RequisitesAndRewards1["rewards"]["cards"]
		2:
			reqandrew = global_event_card.resource.RequisitesAndRewards2["rewards"]["cards"]
		3:
			reqandrew = global_event_card.resource.RequisitesAndRewards3["rewards"]["cards"]
			
	# 1. Coletar todas as cartas recompensa
	for card_name in reqandrew:
		rewards.append(card_name) #QUANTAS CARTAS PRECISA-SE ENTREGAR

	if rewards.is_empty():
		control.error_message("Event Completed! Congrats!")
		finish_event()
		score()
		return # nada a fazer

	var free_slots: Array[StringName] = [] #QUANTOS SLOTS LIVRES TEMOS PARA ENTREGAR
	var slot_number := 1 #SLOT1, SLOT 2 E SLOT 3
	var max_slots := 3 #HOW MANY SLOTS DO WE HAVE - HAS TO BE UPDATED IF WE ADD MORE

	free_slots = count_empty_slots(max_slots, free_slots, slot_number) #returns free_slots
		
	# 3. Se há slots suficientes, entregar as cartas
	if free_slots.size() >= rewards.size():
		for index in range(rewards.size()):
			var slot_path = free_slots[index]
			var slot = slot_manager.get_node(str(slot_path))
			var pos = slot.position
			var card_name = rewards[index]
		
			deck.receive_card(card_name, pos)
		
		control.error_message("Event Completed! Congrats!")
		finish_event()
		score()
	else:
		control.error_message("Free up the slots, take your cards!")
		return

func finish_event():

	erase_global_event_and_block_buttons()
	add_events_from_cards_in_hand()

func skip_event():
	if global_event_card == null:
		control.error_message("No event active at this moment!")
		return -1
	else:
		match global_event_card.resource.skippable:
			0: #normal
				control.error_message("Event skipped!")
				finish_event()
			1: #badluck skipabble
				for i in global_event_card.resource.bad_luck_cards_if_skip:
					deck.instantiate_card("bad_luck", deck.position)
				control.error_message("Event skipped!")
				finish_event()
			2: #you lose if skip
				get_tree().reload_current_scene() 
				return
			_:
				pass
		disable_skip()

func erase_global_event_and_block_buttons():
	var tween = get_tree().create_tween()
	tween.tween_property(global_event_card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
	
	control.deactivate_options_area()
	disable_skip()
	
	await tween.finished
	global_event_card.queue_free()
	
	unlock_current_event()
	


#func disable_doit():
	#control.deactivate_doit_button()
#func enable_doit():
	#control.activate_doit_button()
func disable_skip():
	control.deactivate_skip_button()
func enable_skip():
	control.activate_skip_button()
	
func add_events_from_cards_in_hand(): #triggered every time a card is added or removed from player hand
	
	var card_type_quantity_in_player_hand = {
		0: 0, #WEAPON
		1: 0, #ARMOR
		2: 0, #CONSUMABLE
		3: 0, #MONSTER
		4: 0, #GENERIC
		5: 0, #MONEY
		6: 0  #BADLUCK
	}
	
	for i in player_hand.player_hand:
		card_type_quantity_in_player_hand[i.card_type] += 1
	
	if card_type_quantity_in_player_hand[6] >= 2 and event_deck.bad_luck_events_are_active == false: #bad luck
		event_deck.activate_badluck_events()
	if card_type_quantity_in_player_hand[6] < 2 and event_deck.bad_luck_events_are_active == true: #bad luck
		event_deck.deactivate_badluck_events()

func animate_cards(array_of_cards_to_destroy, array_of_slots_to_free):
	for card in array_of_cards_to_destroy:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		erase_card(card, tween)
		
	for slot in array_of_slots_to_free:
		slot.has_card = false
		slot.card_in_slot = null

func erase_card(card, tween):
	await tween.finished 
	card.queue_free()

func count_empty_slots(max_slots, free_slots, slot_number):
	for i in max_slots: #CONTANDO SLOTS LIVRES
		var slot_path := "SlotMiddle" + str(slot_number)
		var slot = slot_manager.get_node(slot_path)
		
		if slot.card_in_slot == null:
			free_slots.append(slot_path)
			
		slot_number += 1
	return free_slots
