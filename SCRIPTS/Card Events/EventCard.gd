extends Node2D

var resource: Resource
@onready var deck: Node2D = $"../../EventDeck"
@onready var requisites_sprites: Node2D = $RequisitesSprites
@onready var rewards_sprites: Node2D = $RewardsSprites

func _ready() -> void:
	requisites_sprites.visible = true
	rewards_sprites.visible = true
	
