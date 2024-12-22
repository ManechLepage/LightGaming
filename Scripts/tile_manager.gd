extends Node2D

@onready var background: TileMapLayer = $Background
@onready var obstacles: TileMapLayer = $Obstacles
@onready var player: TileMapLayer = $Player

@export var player_position: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	isMoving()
	update_player()

func update_player():
	for tile in player.get_used_cells():
		player.erase_cell(tile)
	player.set_cell(player_position)

func isMoving():
	var direction = Input.get_vector("Left", "Right", "Down", "Up")
	player_position += direction
	
