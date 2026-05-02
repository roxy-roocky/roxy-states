@tool
extends Node
class_name RS_MachineStates

signal StateChanged(previous: String, current: String)

var _States: Array[String]
@export var States: Array[String]:
	get:
		return _States
	set(val):
		_States = val
		if is_node_ready(): UpdateStates()

var _Transitions: Array[RS_Transition]
@export var Transitions: Array[RS_Transition]:
	get:
		return _Transitions
	set(val):
		_Transitions = val
		if is_node_ready(): UpdateStates()

# Update state in subobjects
func UpdateStates():
	for trans in Transitions:
		if trans != null:
			trans.States = _States
			trans.MachineStateName = name
			trans.notify_property_list_changed()
			trans.CheckStates()
	notify_property_list_changed()

var PreviousState: String

var _CurrentState: String
var CurrentState: String:
	get:
		return _CurrentState
	set(val):
		PreviousState = _CurrentState
		_CurrentState = val
		print("%s: %s -> %s" % [name, PreviousState, _CurrentState])
		StateChanged.emit(PreviousState, _CurrentState)

var StartingState: String
func _get_property_list() -> Array[Dictionary]:
	return [{
		"name": "StartingState",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(_States)
	},
	{
		"name": "CurrentState",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY
	}]

@export_tool_button("Reset State", "Reload")
var reset_button := ResetState
func ResetState():
	CurrentState = StartingState
	
@export var Enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_CurrentState = StartingState
	UpdateStates()
	
