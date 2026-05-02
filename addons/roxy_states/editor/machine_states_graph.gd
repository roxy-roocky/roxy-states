@tool
extends PanelContainer

signal MachineStatesSelected()
signal MachineStatesDisappeared()

@onready var GraphEditNode: GraphEdit = $VBoxContainer/GraphEdit
@onready var NodeNameLabelNode: Label = $VBoxContainer/NodeNameLabel

var StateNodePrefab: PackedScene = preload("res://addons/roxy_states/editor/state_node.tscn")
var CurrentMachineStates: RS_MachineStates
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	EditorInterface.get_selection().selection_changed.connect(_OnSelectionChanged)
	print("[RoxyState] Machine state graph ready !")

func _OnSelectionChanged():
	print("[RoxyState] Check selection")
	var result = EditorInterface.get_selection().get_top_selected_nodes().filter(func (el): return el is RS_MachineStates)
	if !result.is_empty() and result[0] != CurrentMachineStates:
		CurrentMachineStates = result[0]
		var root = EditorInterface.get_edited_scene_root()
		NodeNameLabelNode.text = root.name if CurrentMachineStates == root else root.get_path_to(CurrentMachineStates)
		CurrentMachineStates.tree_exited.connect(func (): 
			CurrentMachineStates = null
			MachineStatesDisappeared.emit()
		)
		print("[RoxyState] Detect Machine State %s" % CurrentMachineStates.name)
		_PopulateGraphFromMachineState()
		MachineStatesSelected.emit()

func _PopulateGraphFromMachineState():
	# Empty graph
	for child in GraphEditNode.get_children().filter(func (el): return el is GraphElement or el is GraphNode or el is GraphFrame):
		GraphEditNode.remove_child(child)
		child.queue_free()
	if CurrentMachineStates != null:
		# Populate States
		for state in CurrentMachineStates.States:
			var node = StateNodePrefab.instantiate() as _RS_StateNode
			node.title = state
			GraphEditNode.add_child(node)
		GraphEditNode.arrange_nodes()
		
func _exit_tree() -> void:
	EditorInterface.get_selection().selection_changed.disconnect(_OnSelectionChanged)
