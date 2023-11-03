extends Node

var debugInfoArr : Array = []

class DebugInfo:
	var id : String = "id"
	var text : String = "text"

func add(_id : String):
	var info = DebugInfo.new()
	info.id = _id
	info.text = "text"	
	debugInfoArr.append(info)

func remove(id : String):
	for i in debugInfoArr.size():
		if str(debugInfoArr[i].id) == id:
			debugInfoArr.remove_at(i)

func update(id : String, text : String):
	for i in debugInfoArr.size():
		if str(debugInfoArr[i].id) == id:
			#If found a matching id, update text
			debugInfoArr[i].text = text
			return
	
	#If can't find, create one
	print("Creating " + id)
	add(str(id))
	update(id, text)
