class_name LevelManager
extends Node

@onready var tile_manager: Node2D = $"../TileManager"
@onready var environment_light: PointLight2D = $"../EnvironmentLight"
@onready var gun: GunDisplay = %Gun

func load_level(level: Level) -> void:
	gun.reset()
	environment_light.texture = level.environment_lighting

func win_level():
	print("won level")

func kill_player():
	print("player killed")
