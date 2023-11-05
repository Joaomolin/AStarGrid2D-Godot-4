extends CharacterBody2D

@onready var player: Node2D = %Player

#Grid
@onready var tileMap: TileMap = %TileMap
@onready var tileSize = tileMap.tile_set.tile_size
@onready var currentTile : Vector2 = player.position
var finalTile : Vector2
var gridPlayerTile : Rect2
var gridTargetTile : Rect2
var grid: AStarGrid2D
var idPath:PackedVector2Array
var printIdPath:PackedVector2Array

func _ready():
	_startGrid()
	_updateWalkableTiles()

func _draw():
	#_drawPathToWalk()
	_drawMapTiles()
	pass
	
func _physics_process(_delta):
	
	#_wasdWalk()
	_mouseWalk()
	
	_updateDebugInfo()
	
	queue_redraw()
	
func _input(event: InputEvent):	
	if event.is_action_pressed("ui_accept"):
		#Update end of path
		finalTile = get_global_mouse_position()

#region Grid Setup

func _updateWalkableTiles():
	for x in tileMap.get_used_rect().size.x:
		for y in tileMap.get_used_rect().size.y:
			var tilePos = Vector2i(x + tileMap.get_used_rect().position.x, y + tileMap.get_used_rect().position.y)
			
			var tileData
			
			#Ground layer
			tileData = tileMap.get_cell_tile_data(0, tilePos)
			if !tileData:
				grid.set_point_solid(tilePos)
			
			#Fence layer
			tileData = tileMap.get_cell_tile_data(1, tilePos)
			if tileData:
				grid.set_point_solid(tilePos)
			
func _startGrid():	
	#Start grid
	grid = AStarGrid2D.new()
	grid.region = tileMap.get_used_rect()
	grid.cell_size = tileMap.tile_set.tile_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()
#endregion

#region Walk with WASD
#Doesn't work all on edges

func _wasdWalk():
	var _speed = 120
	var _horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var _vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#Don't walk diagonally
	if abs(_horizontal_input) > abs(_vertical_input):
		velocity = Vector2(_horizontal_input, 0).normalized() * _speed
	else:
		velocity = Vector2(0, _vertical_input).normalized() * _speed
		
	var current_position = get_global_transform().origin
	var intended_position = current_position + Vector2(_horizontal_input, _vertical_input).normalized() * _speed * get_process_delta_time()

	if _isValidWASDPosition(intended_position):
		move_and_slide()
	
func _isValidWASDPosition(intended_position):
	var tilemapOrigin = tileMap.get_used_rect().position

	var intendedTilePosition = (intended_position - Vector2(tilemapOrigin)) / Vector2(tileSize)

	if tileMap.get_cell_tile_data(0, intendedTilePosition):
		#Walking on land
		return true
	
	if tileMap.get_cell_tile_data(1, intendedTilePosition):
		#Walking on land
		return false

#endregion

#region Walk with Mouse
func _mouseWalk():
	if idPath.size() < 2:
		_updatePathToWalk()
		return
	
	var targetPos = idPath[1]
	
	player.global_position = player.global_position.move_toward(targetPos, 1.2)
	
	if player.global_position == targetPos:
		_updatePathToWalk()
		
func _updatePathToWalk():
	var _from = tileMap.local_to_map(player.position)
	var _to = tileMap.local_to_map(finalTile)
		
	idPath = grid.get_id_path(_from, _to)
	
	#Print path
	printIdPath = idPath		
	for i in printIdPath.size(): #Fix positions
		printIdPath[i] = tileMap.map_to_local(printIdPath[i])

#endregion

#region Draw Tiles

func _drawMapTiles():
	if tileMap:
		#Draw squares on tiles
		var arrayOfCells = tileMap.get_used_cells(0)#Get terrain cells
		for i in arrayOfCells.size():
			var _cellX = arrayOfCells[i].x * tileSize.x - get_transform().origin.x # fix vectors origin pos to upper left corner of screen
			var _cellY = arrayOfCells[i].y * tileSize.y - get_transform().origin.y # fix vectors origin pos to upper left corner of screen
			var _tile = Rect2(_cellX, _cellY, tileSize.x, tileSize.y)
			
			#Update player tile
			var _isPlayer = tileMap.local_to_map(player.position) == Vector2i(arrayOfCells[i].x, arrayOfCells[i].y)
			if (_isPlayer):
				gridPlayerTile = _tile
				
			#Update target tile
			var _isWalkTarget = tileMap.local_to_map(finalTile) == Vector2i(arrayOfCells[i].x, arrayOfCells[i].y)
			if (_isWalkTarget):
				gridTargetTile = _tile
			
			#draw_rect(_tile, Color.RED, false)
	#Draw above grid
	#draw_rect(gridPlayerTile, Color.GREEN, false) 
	draw_rect(gridTargetTile, Color.BLUE, false) 
	
func _drawPathToWalk():
	if printIdPath.size() > 1:
		#Draw path line
		var _fixedVectors = printIdPath.duplicate()
		for i in _fixedVectors.size():
			_fixedVectors[i] -= player.position
		draw_polyline(_fixedVectors, Color.RED)
		
		#Draw circles on center of path tiles
		for i in printIdPath.size():
			draw_circle(printIdPath[i] - player.position, 1, Color.RED)

#endregion

func _updateDebugInfo():
	var _xPos = str(snapped(self.position.x, 0.1))
	var _yPos = str(snapped(self.position.y, 0.1))
	Debug.update("PlayerInfo", "Player Pos: " + _xPos + ", Y: " +  _yPos + " / " + str(tileMap.local_to_map(player.global_position)) + " / " + str(tileMap.map_to_local(player.global_position)))
