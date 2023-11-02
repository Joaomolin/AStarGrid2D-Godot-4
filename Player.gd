extends CharacterBody2D
#Player
var myTile:Vector2

#Start
@onready var player: Node2D = %Player
@onready var tileMap: TileMap = %TileMap
@onready var tileSize = tileMap.tile_set.tile_size
var grid: AStarGrid2D

#
var idPath:PackedVector2Array
var otherIdPath:PackedVector2Array

func _ready():
	#Debug
	Debug.add(str(self))
	
	#Start grid
	grid = AStarGrid2D.new()
	grid.region = tileMap.get_used_rect()
	grid.cell_size = tileMap.tile_set.tile_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("ui_accept"):	return
	
	var _from = tileMap.local_to_map(myTile)
	var _to = tileMap.local_to_map(get_global_mouse_position())
	idPath = grid.get_id_path(_from, _to)
	
	otherIdPath = idPath		
	for i in otherIdPath.size(): #Fix positions
		otherIdPath[i] = tileMap.map_to_local(otherIdPath[i])
		#otherIdPath[i] = tileMap.map_to_local(otherIdPath[i]) - global_position
	
func _draw():
	#If has path to walk
	if otherIdPath.size() > 1:
		#Draw path line
		draw_polyline(otherIdPath, Color.RED)
		
		#Draw circles on center of path tiles
		for i in otherIdPath.size():
			draw_circle(otherIdPath[i], 1, Color.RED)

	if tileMap:
		#Draw squares on tiles
		var arrayOfCells = tileMap.get_used_cells(0)#Get terrain cells
		for i in arrayOfCells.size():
			var _cellX = arrayOfCells[i].x * tileSize.x - get_transform().origin.x # fix vectors origin pos to upper left corner of screen
			var _cellY = arrayOfCells[i].y * tileSize.y - get_transform().origin.y # fix vectors origin pos to upper left corner of screen
			draw_rect(Rect2(_cellX, _cellY, tileSize.x, tileSize.y), Color.RED, false) 

func get_input():
	var _speed = 150
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * _speed

func _physics_process(delta):
	var _xPos = str(snapped(self.position.x, 0.01))
	var _yPos = str(snapped(self.position.y, 0.01))
	Debug.update(str(self), "X: " + _xPos + ", Y: " + _yPos)
	
	get_input()
	move_and_slide()
	
	queue_redraw()
