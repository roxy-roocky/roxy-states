@tool
extends Node
class_name RS_MachineStates

var _States: Array[String]
@export var States: Array[String]:
	get:
		return _States
	set(val):
		_States = val
		UpdateStates()

var _Transitions: Array[RS_Transition]
@export var Transitions: Array[RS_Transition]:
	get:
		return _Transitions
	set(val):
		_Transitions = val
		UpdateStates()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateStates()

func UpdateStates():
	for trans in Transitions:
		if trans != null:
			trans.States = _States
			trans.notify_property_list_changed()
