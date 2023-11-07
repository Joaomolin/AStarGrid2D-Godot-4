extends CharacterBody2D
@onready var player: Node2D = %Player

#Grid
@onready var tileMap: TileMap = %TileMap
@onready var tileSize = tileMap.tile_set.tile_size
@onready var finalTile : Vector2 = player.position
var grid: AStarGrid2D
var idPath:PackedVector2Array

#Debug buttons
var printPath : bool = true
var printGrid : bool = true
var allowMouseInput : bool = true
var allowWASDInput : bool = true

func _ready():	
	print(str(self.position)) 
	Debug.update("helpText1", "Walk with WASD/Arrow keys")
	Debug.update("helpText2", "Or use Mouse click/Space bar")
	Debug.update("helpText3", " ")
	#If WASD or Mouse click not working, add them in Project > Input Map
	
	_startGrid()
	_setWalkableTiles()

func _draw():
	_drawPathToWalk()
	_drawMapTiles()
	
func _process(_delta):
	_playerWalk()
	queue_redraw() #Comment to remove grid
	
	#Update debug info
	Debug.update("PlayerGrid", "Pathwalk From: " + str(tileMap.local_to_map(player.position)) + ", To: " + str(tileMap.local_to_map(finalTile)))
	Debug.update("MouseGrid", "Mouse tile: " + str(tileMap.local_to_map(get_global_mouse_position())))

#region Grid Setup
	
func _startGrid():	
	#Start grid
	grid = AStarGrid2D.new()
	grid.region = tileMap.get_used_rect()
	grid.cell_size = tileMap.tile_set.tile_size
	#To enable diagonal movement, comment the line below
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER 
	grid.update()
	
func _setWalkableTiles():
	for x in tileMap.get_used_rect().size.x:
		for y in tileMap.get_used_rect().size.y:
			var _gridTile = Vector2i(x + tileMap.get_used_rect().position.x, y + tileMap.get_used_rect().position.y)
	
			if !_isWalkableTile(_gridTile):
				grid.set_point_solid(_gridTile)

#endregion

#region Player Movement

func _playerWalk():
	if allowMouseInput:
		_mouseInput()
	if allowWASDInput:
		_wasdInput()
	
	if idPath.size() < 2:
		_updatePathToWalk()
		return
	
	var targetPos = idPath[1]
	var _speed = 1.5
	player.global_position = player.global_position.move_toward(targetPos, _speed)
	
	if player.global_position == targetPos:
		_updatePathToWalk()

func _updatePathToWalk():
	var _from = tileMap.local_to_map(player.position)
	var _to = tileMap.local_to_map(finalTile)
		
	idPath = grid.get_id_path(_from, _to)
	
	for i in idPath.size(): #Fix positions
		idPath[i] = tileMap.map_to_local(idPath[i])

func _isWalkableTile(tile : Vector2i) -> bool:
	#Ground layer
	#If IS NOT a ground layer, can't walk
	var groundLayer = 1
	if !tileMap.get_cell_tile_data(groundLayer, tile):
		return false
	
	#Overlay layer
	#If IS Overlay, can't walk
	var overlayLayer = 2
	if tileMap.get_cell_tile_data(overlayLayer, tile):
		return false
	
	return true

#endregion

#region Walk with Mouse/Space bar

func _mouseInput():	
	if Input.is_action_pressed("ui_accept"):
		#Update finalTile as mouse position, if is a walkable tile
		if _isWalkableTile(tileMap.local_to_map(get_global_mouse_position())):
			finalTile = get_global_mouse_position()

#endregion

#region Walk with WASD/Arrows

func _wasdInput():
	var _walkVector = Vector2(0, 0)
	var _noDiagonal = grid.diagonal_mode == AStarGrid2D.DIAGONAL_MODE_NEVER
	
	if Input.is_action_pressed("ui_left"):
		if _noDiagonal:
			_walkVector = Vector2(-tileSize.x, 0)
		else:
			_walkVector += Vector2(-tileSize.x, 0)
			
		
	if Input.is_action_pressed("ui_right"):
		if _noDiagonal:
			_walkVector = Vector2(tileSize.x, 0)
		else:
			_walkVector += Vector2(tileSize.x, 0)
			
	if Input.is_action_pressed("ui_up"):
		if _noDiagonal:
			_walkVector = Vector2(0, -tileSize.y)
		else:
			_walkVector += Vector2(0, -tileSize.y)
			
	if Input.is_action_pressed("ui_down"):
		if _noDiagonal:
			_walkVector = Vector2(0, tileSize.y)
		else:
			_walkVector += Vector2(0, tileSize.y)
			
	Debug.update("_walkVector", "WASD Walk: " + str(_walkVector / Vector2(tileSize)))
	if _walkVector:
		finalTile = player.position + _walkVector

#endregion

#region Draw Tiles on the screen

func _drawMapTiles():
	var _playerTile : Rect2
	var _targetTile : Rect2
	
	if tileMap:
		#Draw squares on tiles
		var _terrainCell = 1
		var arrayOfCells = tileMap.get_used_cells(_terrainCell)#Get terrain cells
		for i in arrayOfCells.size():
			#Create tile
			var _cellX = arrayOfCells[i].x * tileSize.x - get_transform().origin.x # fix vectors origin pos to upper left corner of screen
			var _cellY = arrayOfCells[i].y * tileSize.y - get_transform().origin.y # fix vectors origin pos to upper left corner of screen
			var _tile = Rect2(_cellX, _cellY, tileSize.x, tileSize.y)
			
			#Update player tile
			var _isPlayer = tileMap.local_to_map(player.position) == Vector2i(arrayOfCells[i].x, arrayOfCells[i].y)
			if (_isPlayer):
				_playerTile = _tile
				
			#Update target tile
			var _isWalkTarget = tileMap.local_to_map(finalTile) == Vector2i(arrayOfCells[i].x, arrayOfCells[i].y)
			if (_isWalkTarget):
				_targetTile = _tile
			
			#Draw red grid above all walkable tiles
			if printGrid:
				_printTile(_tile)
		
	#Draw target tile above red grid
	if printPath:
		_printTile(_targetTile, Color.GREEN)
	#Draw player above red grid
	if printPath:
		_printTile(_playerTile, Color.BLUE)
	
func _printTile(tile : Rect2, color : Color = Color.RED):
	if tile:
		draw_rect(tile, color, false) 
		
func _drawPathToWalk():	
	if idPath.size() < 2 || !printPath:	return
		
	#Draw path line
	var _fixedVectors = idPath.duplicate()
	for i in _fixedVectors.size():
		_fixedVectors[i] -= player.position
	draw_polyline(_fixedVectors, Color.RED)
	
	#Draw circles on center of tiles
	for i in idPath.size():
		draw_circle(idPath[i] - player.position, 1, Color.RED)
#endregion
