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
	FreeToSkip,
	BadLuck
}

@export var tier: EventCardTier
@export var name: String
@export var description: String
@export var skippable: Skip
