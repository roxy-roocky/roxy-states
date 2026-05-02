@tool
extends Resource
class_name RS_Transition

enum _Mode {
	ALL,
	ANY
}

var States: Array[String]
var MachineStateName: String

@export var Mode: _Mode
var StartState: String
## ALL: all conditions must be true ; ANY: only one condition must be true
@export var Conditions: Array[RS_Condition]
var EndState: String

func CheckStates():
	if !States.has(StartState):
		push_warning("State %s not exists in Machine State %s" % [StartState, MachineStateName])
	if !States.has(EndState):
		push_warning("State %s not exists in Machine State %s" % [EndState, MachineStateName])

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
