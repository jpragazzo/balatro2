extends Resource
class_name Card

enum CardType {
	WEAPON,  #0
	ARMOR,   #1
	CONSUMABLE,  #2
	MONSTER, #3
	GENERIC, #4
	MONEY,  #5
	BADLUCK  #6
} #não se esqueça de atualizar o CardType em event_card_manager.gd, 
#e também o enum EventCardType em event_card_res.gd, 
#e também o CardType em card.gd

enum Tier {
	ONE, TWO, THREE
}

@export var card_type: CardType
@export var tier: Tier

func get_tier():
	return self.tier
	
func get_card_type():
	return self.card_type
