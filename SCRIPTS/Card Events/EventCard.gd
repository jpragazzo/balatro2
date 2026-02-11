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
	
	$Left/Option1/Option1Area/CollisionShape2D.disabled = true
	$Center/Option2/Option2Area/CollisionShape2D.disabled = true
	$Right/Option3/Option3Area/CollisionShape2D.disabled = true
