extends Resource
class_name EventCard

@export var RequisitesAndRewards1 = {
	"requisites": {
		"cards": [],
		"events":[]
	},
	"rewards": {
		"cards": [],
		"events":[]
	},
}

@export var RequisitesAndRewards2 = {
	"requisites": {
		"cards": [],
		"events":[]
	},
	"rewards": {
		"cards": [],
		"events":[]
	},
}

@export var RequisitesAndRewards3 = {
	"requisites": {
		"cards": [],
		"events":[]
	},
	"rewards": {
		"cards": [],
		"events":[]
	},
}

@export var options = {
	"number_of_options": [] #Option description that will be available on the labels.
}

enum Skip {
	FreeToSkip, #0
	BadLuck,    #1
	YouLose
}

enum EventType {
	Normal, #0 
	BadLuck #1
}

@export var name: String
@export var description: String
@export var event_type: EventType
@export var skippable: Skip
@export var bad_luck_cards_if_skip: int
