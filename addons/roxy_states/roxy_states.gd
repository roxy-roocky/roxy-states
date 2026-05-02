@tool
extends EditorPlugin

var machine_states_graph_dock: EditorDock
func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _OnMachineStatesSelected():
	machine_states_graph_dock.make_visible()
	
func _OnMachineStatesDisappeared():
	machine_states_graph_dock.close()

func _enter_tree() -> void:
	var machine_states_graph = preload("res://addons/roxy_states/editor/machine_states_graph.tscn").instantiate() 
	machine_states_graph.MachineStatesSelected.connect(_OnMachineStatesSelected)
	machine_states_graph.MachineStatesDisappeared.connect(_OnMachineStatesDisappeared)
	machine_states_graph_dock = EditorDock.new()
	machine_states_graph_dock.default_slot = EditorDock.DOCK_SLOT_BOTTOM
	machine_states_graph_dock.title = "Machine States"
	machine_states_graph_dock.add_child(machine_states_graph)
	add_dock(machine_states_graph_dock)
	machine_states_graph_dock.close()


func _exit_tree() -> void:
	remove_dock(machine_states_graph_dock)
	machine_states_graph_dock.queue_free()
	pass
