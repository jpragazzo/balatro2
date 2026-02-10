extends Node2D

var resource: Resource
@onready var deck: Node2D = $"../../EventDeck"


func _ready() -> void:
	$Left/RequisitesSprites.visible = true
	$Left/RewardsSprites.visible = true
	$Center/RequisitesSprites.visible = true
	$Center/RewardsSprites.visible = true
	$Right/RequisitesSprites.visible = true
	$Right/RewardsSprites.visible = true
