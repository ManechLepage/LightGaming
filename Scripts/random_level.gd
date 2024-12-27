class_name RandomLevelGenerator
extends Node

@export var environments: Array[Texture2D]
@export var obstacles: Array[Level]

func get_random_environment() -> Texture2D:
	return environments.pick_random()

func get_random_obstacle(difficulty: int) -> TileMapLayer:
	return obstacles.pick_random()
