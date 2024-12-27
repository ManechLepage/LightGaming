class_name TileManager
extends Node2D

@onready var background: TileMapLayer = $Background
var obstacles: TileMapLayer
@onready var player: TileMapLayer = $Player

@onready var level_manager: LevelManager = %LevelManager
@onready var bullets: Node2D = %Bullets
@onready var gun: GunDisplay = %Gun

@onready var light: PointLight2D = %EndLight


var player_position: Vector2i

# Interactions
# -1: Goal
# 0: Wall
# 1: Death

func set_player(position: Vector2i):
	player_position = position
	print(player_position)
	call_deferred("update_player")

func _process(delta: float) -> void:
	print(player_position)
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
			level_manager.bullet_quantity = gun.get_bullet_quantity()
			level_manager.update_bullets.emit(level_manager.bullet_quantity)
			return false
		elif tile_interaction == 0 or tile_interaction == 3:
			return false
		elif tile_interaction == 1:
			level_manager.kill_player()
			return false
		elif tile_interaction == 2:
			level_manager.add_gear()
			obstacles.erase_cell(position)
			destroy_light(position)
	return true

func is_bullet_killed(position: Vector2, offset: Vector2i) -> bool:
	var tile_position: Vector2i = obstacles.local_to_map(position) + offset
	if obstacles.get_cell_tile_data(tile_position):
		if obstacles.get_cell_tile_data(tile_position).get_custom_data("Interaction") == 3:
			destroy_gear(tile_position)
		return obstacles.get_cell_tile_data(tile_position).get_custom_data("KillBullet")
	return false

var lights = []
func duplicate_light(position: Vector2i):
	var new_light = light.duplicate()
	add_child(new_light)


func destroy_gear(position: Vector2i) -> void:
	obstacles.set_cell(position, 0, Vector2i(3, 1))
	duplicate_light(position)
	lights.append(position)
func destroy_light(position: Vector2i):
	for l in lights:
		if l == position:
			light.queue_free()
			
	
func load_obstacles(level: Level) -> void:
	if obstacles:
		obstacles.queue_free()
	obstacles = level.obstacles.instantiate()
	add_child(obstacles)

	
func place_end_light() -> void:
	for i in obstacles.get_used_cells():
		if obstacles.get_cell_tile_data(i):
			if obstacles.get_cell_tile_data(i).get_custom_data("Interaction") == -1:
				light.position = obstacles.map_to_local(i)

func load_end_light() -> void:
	call_deferred("place_end_light")

func place_random_obstacles(difficulty: int) -> void:
	for tile in obstacles.get_used_cells():
		if obstacles.get_cell_atlas_coords(tile) == Vector2i(0, 0):
			var atlas_coords: Vector2i = RandomLevel.get_random_tile(difficulty)
			if atlas_coords == Vector2i(-1, -1):
				obstacles.erase_cell(atlas_coords)
			else:
				obstacles.set_cell(tile, 0, atlas_coords)
