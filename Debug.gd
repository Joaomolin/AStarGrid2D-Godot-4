extends Node

var debugInfoArr : Array = []

class DebugInfo:
	var key : String = "key"
	var value : String = "value"

func add(_key : String):
	var info = DebugInfo.new()
	info.key = _key
	info.value = "value"
	debugInfoArr.append(info)
		
func update(key : String, value : String):
	for i in debugInfoArr.size():
		if str(debugInfoArr[i].key) == key:
			debugInfoArr[i].value = value
