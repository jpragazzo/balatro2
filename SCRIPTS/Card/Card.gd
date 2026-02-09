extends Node2D

signal hovered
signal hovered_off

var card_type
var card_tier
var hand_original_pos
var current_slot = null

var resource: Resource
@onready var deck: Node2D = $"../../Deck"
@onready var card_sprite: Sprite2D = $CardSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#deck.send_card_sprite_and_res.connect(set_sprite_and_resource)
	get_parent().connect_card_signals(self)
	
	self.get_node("Attack").visible = false
	self.get_node("Health").visible = false
	self.get_node("Attack2").visible = false
	self.get_node("Health2").visible = false
	self.get_node("Shield").visible = false
	
	match self.resource.card_type:
		0: #weapon
			card_sprite.modulate = Color(0.7, 0.9, 0.95, 1)
			self.get_node("Attack2").visible = true
			self.get_node("Attack").visible = true
			self.get_node("Attack").text = str(self.resource.damage)
		2: #consumable
			card_sprite.modulate = Color(0.95, 0.8, 0.75, 1)
			pass
		1: #armor
			card_sprite.modulate = Color(0.7, 0.8, 0.98, 1)
			self.get_node("Shield").visible = true
			self.get_node("Health").visible = true
			self.get_node("Health").text = str(self.resource.defense)
		3:
			card_sprite.modulate = Color(0.85, 0.7, 0.85, 1)
			self.get_node("Health").visible = true
			self.get_node("Attack").visible = true
			self.get_node("Health").text = str(self.resource.health)
			self.get_node("Attack").text = str(self.resource.damage)
			self.get_node("Attack2").visible = true
			self.get_node("Health2").visible = true
		#4:
			#generic, not implemented
		5: #money
			card_sprite.modulate = Color(1, 0.9, 0.5, 1) #para hex: #FFF2B8
			self.get_node("Attack").visible = false
			self.get_node("Health").visible = false
			self.get_node("Attack2").visible = false
			self.get_node("Health2").visible = false
			self.get_node("Shield").visible = false
		6: #badluck
			card_sprite.modulate = Color(1, 0.6, 0.6, 1) #para hex: #FF9999
			self.get_node("Attack").visible = false
			self.get_node("Health").visible = false
			self.get_node("Attack2").visible = false
			self.get_node("Health2").visible = false
			self.get_node("Shield").visible = false



	tiering()

func tiering():
	match card_tier: #DYNAMIC TIERING IN THE LABEL "$Tier"
		_: 
			$Tier.text = "T" + str(card_tier + 1)

func _on_generic_card_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_generic_card_mouse_exited() -> void:
	emit_signal("hovered_off", self)
