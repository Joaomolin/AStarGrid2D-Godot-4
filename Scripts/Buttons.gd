extends Node2D

@onready var player: Node2D = %Player

#btns

@onready var btn_diagonal: Button = %BtnDiagonal
@onready var btn_path_draw: Button = %"BtnPath Draw"
@onready var btn_grid_draw: Button = %"BtnGrid Draw"
@onready var btn_mouse_walk: Button = %"BtnMouse Walk"
@onready var btn_wasd_walk: Button = %"BtnWASD Walk"

func _ready():
	_updateButtonsColors()

func _updateButtonsColors():
	_colorBtn(btn_diagonal, bool(player.grid.diagonal_mode != AStarGrid2D.DIAGONAL_MODE_NEVER))
	_colorBtn(btn_path_draw, player.printPath)
	_colorBtn(btn_grid_draw, player.printGrid)
	_colorBtn(btn_mouse_walk, player.allowMouseInput)
	_colorBtn(btn_wasd_walk, player.allowWASDInput)

func _colorBtn(btn : Button, boolean : bool):
		btn.set("theme_override_colors/font_color", Color.GREEN if boolean else Color.RED)
		btn.set("theme_override_colors/font_pressed_color", Color.GREEN if boolean else Color.RED)
		btn.set("theme_override_colors/font_hover_color", Color.GREEN if boolean else Color.RED)
		btn.set("theme_override_colors/font_focus_color", Color.GREEN if boolean else Color.RED)
		btn.set("theme_override_colors/font_hover_pressed_color", Color.GREEN if boolean else Color.RED)

func _on_diagonal_mode_pressed() -> void:
	const _diagonal = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	const _grid = AStarGrid2D.DIAGONAL_MODE_NEVER
	var _diagonalMode = player.grid.diagonal_mode != AStarGrid2D.DIAGONAL_MODE_NEVER
	#Can change between diagonal modes
	if _diagonalMode:
		player.grid.diagonal_mode =  _grid
	else:
		player.grid.diagonal_mode =  _diagonal
	_updateButtonsColors()

func _on_toggle_path_pressed() -> void:
	player.printPath = !player.printPath
	_updateButtonsColors()

func _on_toggle_grid_pressed() -> void:
	player.printGrid = !player.printGrid
	_updateButtonsColors()

func _on_toggle_mouse_walk_pressed() -> void:
	player.allowMouseInput = !player.allowMouseInput
	_updateButtonsColors()
	
func _on_toggle_WASD_movement_pressed() -> void:
	player.allowWASDInput = !player.allowWASDInput
	_updateButtonsColors()
