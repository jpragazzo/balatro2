extends Node2D

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"
@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var control: Control = $"../Control"

# var event_deck = ["give2cards", "receive2cards", "give1cards", "hunger", "blacksmith", "thebutcher", "thievery"]
var event_deck = load_tres_resources_from_folder("res://RESOURCES/events/")
var bad_luck_events_are_active = false


func _ready():
	remove_badluck_events()

func draw_event_card(): #SMART CARD DRAWING EXPERIENCE: add
	
	#event_deck.shuffle()
	
	var resource_path = event_deck[0].resource_path
	var file_name = resource_path.get_file()
	
	var event_card_drawn = file_name
	
	var event_card_scene = preload("res://scenes/event_card.tscn")
	var new_card = event_card_scene.instantiate() #CREATING EVENT CARD
	new_card.position = self.position
	new_card.resource = load("res://RESOURCES/events/"+event_card_drawn)
	new_card.get_node("Main/EventName").text = new_card.resource.name
	new_card.get_node("Main/EventDescription").text = new_card.resource.description
	event_card_manager.start_event(new_card)
	
	card_manager.add_child(new_card)
	
	update_event_card_position(new_card, Vector2(get_viewport().get_visible_rect().size.x / 2, self.position.y - 200))
	update_event_card_scale(new_card, Vector2(1.7,1.7))
	
func activate_badluck_events():
	bad_luck_events_are_active = true
	%DebugLabel.text = str(bad_luck_events_are_active)
	add_badluck_events()

func deactivate_badluck_events():
	bad_luck_events_are_active = false
	%DebugLabel.text = str(bad_luck_events_are_active)
	remove_badluck_events()

func add_badluck_events():
	event_deck = load_tres_resources_from_folder("res://RESOURCES/events/")
func remove_badluck_events():
	for event in event_deck:
		if event.event_type == 1:
			event_deck.erase(event)

func load_tres_resources_from_folder(path: String) -> Array:
	var resources: Array = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var res_path = path + "/" + file_name
				var resource = load(res_path)
				if resource:
					resources.append(resource)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Could not open folder: " + path)
	return resources

func update_event_card_position(event_card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(event_card, "position", new_position, 0.3)
	
	await tween.finished
	control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = false

func update_event_card_scale(event_card, new_scale):

	var tween2 = get_tree().create_tween()
	tween2.tween_property(event_card, "scale", new_scale, 0.2)


	
	
