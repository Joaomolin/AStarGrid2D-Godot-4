extends Node

var debugInfoArr : Array = []

#To use, just call Debug.update(id, text) anywhere, and to remove use Debug.remove(id).
class DebugInfo:
	var id : String = "id"
	var text : String = "text"

func add(_id : String):
	var info = DebugInfo.new()
	info.id = _id
	info.text = "text"	
	debugInfoArr.append(info)

func remove(_id : String):
	for i in debugInfoArr.size():
		if str(debugInfoArr[i].id) == _id:
			debugInfoArr.remove_at(i)

func update(_id : String, _text : String):
	for i in debugInfoArr.size():
		if str(debugInfoArr[i].id) == _id:
			#If found a matching id, update text
			debugInfoArr[i].text = _text
			return
	
	#If can't find, create one 
	#print("Creating " + _id)
	add(str(_id))
	update(_id, _text)
