extends CanvasLayer

@onready var debug_info_container: VBoxContainer = %DebugInfoContainer

func _process(_delta):
	if Debug.debugInfoArr.size() > debug_info_container.get_child_count():
		debug_info_container.add_child(Label.new())
	elif Debug.debugInfoArr.size() < debug_info_container.get_child_count():
		debug_info_container.remove_child(debug_info_container.get_children()[0])
	else:
		for i in min(Debug.debugInfoArr.size(), debug_info_container.get_child_count()):
			debug_info_container.get_child(i).text = Debug.debugInfoArr[i].key + ": " + Debug.debugInfoArr[i].value
