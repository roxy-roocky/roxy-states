@tool
extends Resource
class_name RS_Transition

enum _Mode {
	ALL,
	ANY
}

var States: Array[String]

@export var Mode: _Mode
var StartState: String
@export var Conditions: Array[RS_Condition]
var EndState: String

func _get_property_list() -> Array[Dictionary]:
	return [{
		"name": "StartState",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(States)
	},
	{
		"name": "EndState",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(States)
	}]
