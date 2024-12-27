class_name TileManager
extends Node2D

@onready var background: TileMapLayer = $Background
@onready var obstacles: TileMapLayer = $Obstacles
@onready var player: TileMapLayer = $Player

@onready var level_manager: LevelManager = %LevelManager
@onready var bullets: Node2D = %Bullets
@onready var gun: GunDisplay = %Gun

var player_position: Vector2i

# Interactions
# -1: Goal
# 0: Wall
# 1: Death

func _ready() -> void:
	print(gun is GunDisplay)
	player_position = player.get_used_cells()[0]

func _process(delta: float) -> void:
	update_player()
	update_gun()

func get_player_position() -> Vector2:
	return player.map_to_local(player_position)

func update_player():
	for tile in player.get_used_cells():
		player.erase_cell(tile)
	player.set_cell(player_position, 0, Vector2(0, 0))

func update_gun():
	gun.position = get_player_position()
	gun.rotation = (get_global_mouse_position() - gun.position).normalized().angle()
	gun.update_gun()

func _input(event: InputEvent) -> void:
	var new_position: Vector2i = player_position
	if Input.is_action_just_pressed("Up"):
		new_position -= Vector2i(0, 1)
	elif Input.is_action_just_pressed("Down"):
		new_position += Vector2i(0, 1)
	elif Input.is_action_just_pressed("Left"):
		new_position -= Vector2i(1, 0)
	elif Input.is_action_just_pressed("Right"):
		new_position += Vector2i(1, 0)
	
	if can_move(new_position):
		player_position = new_position


func can_move(position: Vector2i) -> bool:
	if bullets.get_child_count() > 0:
		return false
	if not manage_interaction(position):
		return false
	return true

func manage_interaction(position: Vector2i) -> bool:
	if position in obstacles.get_used_cells():
		var tile: TileData = obstacles.get_cell_tile_data(position)
		var tile_interaction: int = tile.get_custom_data("Interaction")
		if tile_interaction == -1:
			level_manager.win_level()
		elif tile_interaction == 0 or tile_interaction == 3:
			return false
		elif tile_interaction == 1:
			level_manager.kill_player()
		elif tile_interaction == 2:
			print("+1 Gear")
			obstacles.erase_cell(position)
	return true

func is_bullet_killed(position: Vector2, offset: Vector2i) -> bool:
	var tile_position: Vector2i = obstacles.local_to_map(position) + offset
	if obstacles.get_cell_tile_data(tile_position):
		if obstacles.get_cell_tile_data(tile_position).get_custom_data("Interaction") == 3:
			destroy_gear(tile_position)
		return obstacles.get_cell_tile_data(tile_position).get_custom_data("KillBullet")
	return false

func destroy_gear(position: Vector2i) -> void:
	obstacles.set_cell(position, 0, Vector2i(3, 1))
