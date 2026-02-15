extends Node2D

var resource: Resource
@onready var deck: Node2D = $"../../EventDeck"
@onready var control: Control = $"../../Control"
@onready var event_card_manager = self.get_parent()
var yellow = Color(1, 0.95, 0.4, 1)

func _ready() -> void:
	$Left/RequisitesSprites.visible = true
	$Left/RewardsSprites.visible = true
	$Center/RequisitesSprites.visible = true
	$Center/RewardsSprites.visible = true
	$Right/RequisitesSprites.visible = true
	$Right/RewardsSprites.visible = true
	
	control.deactivate_options_area()
	control.deactivate_main_area()


func option_area_shine_signal_left() -> void:
	var sprite = self.get_node("Left/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", yellow, 0.2)
func option_area_unshine_signal_left() -> void:
	var sprite = self.get_node("Left/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)

func option_area_shine_signal_center() -> void:
	var sprite = self.get_node("Center/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", yellow, 0.2)
func option_area_unshine_signal_center() -> void:
	var sprite = self.get_node("Center/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)

func option_area_shine_signal_right() -> void:
	var sprite = self.get_node("Right/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", yellow, 0.2)
func option_area_unshine_signal_right() -> void:
	var sprite = self.get_node("Right/Yellow")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)
