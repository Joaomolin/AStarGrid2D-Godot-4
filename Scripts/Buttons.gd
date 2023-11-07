extends Node2D

@onready var player: Node2D = %Player

func _on_diagonal_mode_pressed() -> void:
	player.grid.diagonal_mode =  0 if player.grid.diagonal_mode else 1
	pass # Replace with function body.

func _on_toggle_path_pressed() -> void:
	player.printPath = !player.printPath
	pass # Replace with function body.

func _on_toggle_grid_pressed() -> void:
	player.printGrid = !player.printGrid
	pass # Replace with function body.

func _on_toggle_mouse_walk_pressed() -> void:
	player.allowMouseInput = !player.allowMouseInput
	pass # Replace with function body.

func _on_toggle_WASD_movement_pressed() -> void:
	player.allowWASDInput = !player.allowWASDInput
	pass # Replace with function body.
