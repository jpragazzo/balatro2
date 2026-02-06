extends Resource
class_name EventCard

@export var RequisitesAndRewards = {
	"requisites": {
		"cards": [],
		"events":[]
	},
	"rewards": {
		"cards": [],
		"events":[]
	},
}


enum EventCardTier {
	ONE,
	TWO,
	THREE
}

enum Skip {
	FreeToSkip, #0
	BadLuck	    #1
}

@export var tier: EventCardTier
@export var name: String
@export var description: String
@export var skippable: Skip
@export var bad_luck_cards_if_skip: int
