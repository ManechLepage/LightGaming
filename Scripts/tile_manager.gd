extends Node2D

@onready var background: TileMapLayer = $Background
@onready var obstacles: TileMapLayer = $Obstacles
@onready var player: TileMapLayer = $Player

@onready var gun: GunDisplay = %Gun

@export var player_position: Vector2i

func _ready() -> void:
	pass

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
	if position in obstacles.get_used_cells():
		return false
	return true
