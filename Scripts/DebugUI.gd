extends VBoxContainer

@onready var debug_background : Panel = %DebugBackground
@export var charSize : Vector2 = Vector2(10, 30)

func _process(_delta):
	#How to use:
	#Debug.update("DebugMenu", "Debug Menu Text")
	
	_checkLabels()
	_resizeBackgroundPanel()
	
func _checkLabels():	
	if Debug.debugInfoArr.size() > self.get_child_count():
	# 	Add a label
		self.add_child(Label.new())
	elif Debug.debugInfoArr.size() < self.get_child_count():
	# 	Remove a label
		self.remove_child(self.get_children()[0])
	else:
		for i in self.get_child_count():
	# 		Update labels 
			self.get_child(i).text = Debug.debugInfoArr[i].text

func _resizeBackgroundPanel():
	#Panel X
	var _biggestString : String = ""	
	for i in self.get_child_count():
		if _biggestString.length() < self.get_child(i).text.length():
			_biggestString = self.get_child(i).text
	debug_background.size.x = _biggestString.length() * charSize.x
	
	#Panel Y	
	if self.get_child_count() > 0:
		debug_background.size.y = self.get_child_count() * charSize.y
	else:
		debug_background.size.y = 0
