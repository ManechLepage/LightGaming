extends Node2D

@onready var background: TileMapLayer = $Background
@onready var obstacles: TileMapLayer = $Obstacles
@onready var player: TileMapLayer = $Player

@export var player_position: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update_player()

func update_player():
	for tile in player.get_used_cells():
		player.erase_cell(tile)
	player.set_cell(player_position, 0, Vector2(0, 0))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Up"):
		player_position -= Vector2(0, 1)
	if Input.is_action_just_pressed("Down"):
		player_position += Vector2(0, 1)
	if Input.is_action_just_pressed("Left"):
		player_position -= Vector2(1, 0)
	if Input.is_action_just_pressed("Right"):
		player_position += Vector2(1, 0)
