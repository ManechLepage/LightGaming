class_name LevelManager
extends Node

@onready var tile_manager: Node2D = $"../TileManager"
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var gun: GunDisplay = %Gun

@export var levels: Array[Level]

func _ready() -> void:
	load_level(levels[0])

func load_level(level: Level) -> void:
	gun.reset()
	animation_player.play(level.environment_lighting)

func win_level():
	print("won level")

func kill_player():
	print("player killed")
