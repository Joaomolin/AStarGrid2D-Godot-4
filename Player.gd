extends Node2D

#Start
@onready var player: Node2D = %Player
@onready var tileMap: TileMap = %TileMap
@onready var tileSize = tileMap.tile_set.tile_size
var grid: AStarGrid2D

#
var idPath:PackedVector2Array
var otherIdPath:PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Start grid
	grid = AStarGrid2D.new()
	grid.region = tileMap.get_used_rect()
	grid.cell_size = tileMap.tile_set.tile_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

func _process(_delta):
	queue_redraw()
	pass

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("ui_accept"):	return
	
	var _from = tileMap.local_to_map(global_position)
	var _to = tileMap.local_to_map(get_global_mouse_position())
	idPath = grid.get_id_path(_from, _to)
	
	otherIdPath = grid.get_point_path(_from, _to)
	for i in otherIdPath.size():		
		otherIdPath[i] -= global_position #Fix start path position to center
		otherIdPath[i] += Vector2(tileSize.x / 2, tileSize.y / 2) #Push vector pos to center of character

func _draw():
	if otherIdPath.size() > 1:
		#Draw path line
		draw_polyline(otherIdPath, Color.RED)
		
		#Draw circles on center of path tiles
		for i in otherIdPath.size():
			draw_circle(otherIdPath[i], 1, Color.RED)
			
	#Draw squares on tiles
	print(tileMap.tile_set.tile_size)
	if tileMap:
		var arrayOfCells = tileMap.get_used_cells(0)
		for i in arrayOfCells.size():
			var _cellX = arrayOfCells[i].x * tileSize.x - 160 # -160 to Fix vectors pos to upper left corner of screen
			var _cellY = arrayOfCells[i].y * tileSize.y - 160 # -160 to Fix vectors pos to upper left corner of screen
			draw_rect(Rect2(_cellX, _cellY, tileSize.x, tileSize.y), Color.RED, false) 
