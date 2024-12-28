class_name TileManager
extends Node2D

@onready var background: TileMapLayer = $Background
var obstacles: TileMapLayer
@onready var player: TileMapLayer = $Player
@onready var input_manager: InputManager = %InputManager

@onready var level_manager: LevelManager = %LevelManager
@onready var bullets: Node2D = %Bullets
@onready var gun: GunDisplay = %Gun

@onready var light: PointLight2D = %EndLight
@onready var walk: AudioStreamPlayer = %Walk


var player_position: Vector2i
var turns = 1
# Interactions
# -1: Goal
# 0: Wall
# 1: Death

func set_player(position: Vector2i):
	player_position = position
	call_deferred("update_player")

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
	if Input.is_action_just_pressed("Win"):
		level_manager.win_level()
	var new_position: Vector2i = player_position
	var s = false
	if not level_manager.death:
		if Input.is_action_just_pressed("Up"):
			new_position -= Vector2i(0, 1)
			s = true
		elif Input.is_action_just_pressed("Down"):
			new_position += Vector2i(0, 1)
			s = true
		elif Input.is_action_just_pressed("Left"):
			new_position -= Vector2i(1, 0)
			s = true
		elif Input.is_action_just_pressed("Right"):
			new_position += Vector2i(1, 0)
			s = true
		
		if input_manager.gameState == input_manager.GameState.ACTIVE:
			if can_move(new_position):
				player_position = new_position
				if s:
					walk.pitch_scale = randf_range(0.8, 2.0)
					walk.play()
					turns += 1
					print(turns)
					s = false
					flaming()

func can_move(position: Vector2i) -> bool:
	if bullets.get_child_count() > 0:
		return false
	if not manage_interaction(position):
		return false
	return true

func remove():
	for tile in obstacles.get_used_cells():
		if obstacles.get_cell_atlas_coords(tile) == Vector2i(2, 0):
			if randi() & 1:
				obstacles.erase_cell(tile)

func manage_interaction(position: Vector2i) -> bool:
	if position in obstacles.get_used_cells():
		var tile: TileData = obstacles.get_cell_tile_data(position)
		var tile_interaction: int = tile.get_custom_data("Interaction")
		if tile_interaction == -1:
			level_manager.win_level()
			level_manager.bullet_quantity += gun.get_bullet_quantity()
			level_manager.update_bullets.emit(level_manager.bullet_quantity)
			return false
		elif tile_interaction == 0 or tile_interaction == 3:
			return false
		elif tile_interaction == 1 or tile_interaction == 4:
			level_manager.kill_player()
			return true
		elif tile_interaction == 2:
			level_manager.add_gear()
			obstacles.erase_cell(position)
			destroy_light(position)
	return true

func is_bullet_killed(position: Vector2, offset: Vector2i) -> bool:
	var tile_position: Vector2i = obstacles.local_to_map(position) + offset
	if obstacles.get_cell_tile_data(tile_position):
		if obstacles.get_cell_tile_data(tile_position).get_custom_data("Interaction") == 3 or obstacles.get_cell_tile_data(tile_position).get_custom_data("Interaction") == 4:
			destroy_gear(tile_position)
		return obstacles.get_cell_tile_data(tile_position).get_custom_data("KillBullet")
	return false

var lights = []
func duplicate_light(position: Vector2i, energy):
	var new_light = light.duplicate()
	new_light.position = obstacles.map_to_local(position)
	new_light.energy = energy
	add_child(new_light)
	lights.append(new_light)

func destroy_gear(position: Vector2i) -> void:
	obstacles.set_cell(position, 0, Vector2i(3, 1))
	duplicate_light(position, 0.5)
func destroy_light(position: Vector2i):
	for l in lights:
		if obstacles.local_to_map(l.position) == position:
			l.queue_free()
			lights.erase(l)
			break
			
	
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
	for tile in obstacles.get_used_cells():
		if obstacles.get_cell_atlas_coords(tile) == Vector2i(3, 0) or obstacles.get_cell_atlas_coords(tile) == Vector2i(4, 0):
			call_deferred("duplicate_light",tile,1)
			
func flamethrower(position: Vector2i):
	var pos: Vector2i
	var l = []
	var r = []
	var u = []
	var d = []
	pos = position
	var switch: bool
	switch = true
	while switch:
		if pos + Vector2i(1,0) not in obstacles.get_used_cells():
			pos += Vector2i(1,0)
			r.append(pos)
		else:
			switch = false
	switch = true
	pos = position
	while switch:
		if pos + Vector2i(-1,0) not in obstacles.get_used_cells():
			pos += Vector2i(-1,0)
			l.append(pos)
		else:
			switch = false
	switch = true
	pos = position
	while switch:
		if pos + Vector2i(0,-1) not in obstacles.get_used_cells():
			pos += Vector2i(0,-1)
			u.append(pos)
		else:
			switch = false
	switch = true
	pos = position
	while switch:
		if pos + Vector2i(0,1) not in obstacles.get_used_cells():
			pos += Vector2i(0,1)
			d.append(pos)
		else:
			switch = false
	for p in r:
		obstacles.set_cell(p,0,Vector2i(6,0))
		duplicate_light(p,1)
	for p in l:
		obstacles.set_cell(p,0,Vector2i(6,2))
		duplicate_light(p,1)
	for p in u:
		obstacles.set_cell(p,0,Vector2i(6,1))
		duplicate_light(p,1)
	for p in d:
		obstacles.set_cell(p,0,Vector2i(6,3))
		duplicate_light(p,1)
func flaming():
	if turns % 5 == 3:
		for tile in obstacles.get_used_cells():
			if obstacles.get_cell_atlas_coords(tile) == Vector2i(4,0):
				obstacles.set_cell(tile, 0, Vector2i(5,0))
	elif turns % 5 == 4:
		for tile in obstacles.get_used_cells():
			if obstacles.get_cell_atlas_coords(tile) == Vector2i(5,0):
				obstacles.set_cell(tile, 0, Vector2i(4,1))
	elif turns != 0 and turns % 5 == 0:
		for tile in obstacles.get_used_cells():
			if obstacles.get_cell_atlas_coords(tile) == Vector2i(4,1):
				obstacles.set_cell(tile, 0, Vector2i(5,1))
				flamethrower(tile)
	elif turns % 5 == 1:
		for tile in obstacles.get_used_cells():
			if obstacles.get_cell_atlas_coords(tile) == Vector2i(5,1):
				obstacles.set_cell(tile, 0, Vector2i(4,0))
			elif obstacles.get_cell_atlas_coords(tile) in [Vector2i(6,0),Vector2i(6,1),Vector2i(6,2),Vector2i(6,3)]:
				obstacles.erase_cell(tile)
				destroy_light(tile)
