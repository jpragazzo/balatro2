extends Node2D

var event_deck = ["give2cards", "receive2cards", "give1cards", "hunger", "blacksmith", "thebutcher"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"
@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var control: Control = $"../Control"
	
func draw_event_card():
	
	event_deck.shuffle()
	
	var event_card_drawn = event_deck[0]
	
	
	var event_card_scene = preload("res://scenes/event_card.tscn")
	var new_card = event_card_scene.instantiate() #CREATING EVENT CARD
	new_card.position = self.position
	new_card.resource = load("res://RESOURCES/events/"+event_card_drawn+".tres")
	new_card.get_node("EventName").text = new_card.resource.name
	new_card.get_node("EventDescription").text = new_card.resource.description
	event_card_manager.start_event(new_card)
	
	card_manager.add_child(new_card)
	
	update_event_card_position(new_card, Vector2(self.position.x - 185, self.position.y))
	update_event_card_scale(new_card, Vector2(1.7,1.7))
	
func add_events_from_cards_in_hand():
	var current_player_hand = player_hand.player_hand #IS AN ARRAY
	
	#ADD LOGIC

func update_event_card_position(event_card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(event_card, "position", new_position, 0.2)
	
	await tween.finished
	control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = false

func update_event_card_scale(event_card, new_scale):

	var tween2 = get_tree().create_tween()
	tween2.tween_property(event_card, "scale", new_scale, 0.2)


	
	
