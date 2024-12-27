class_name RandomLevelGenerator
extends Node

@export var environments: Array[Texture2D]
@export var obstacles: Array[Level]

@export var obstacle_data: Array[Vector2i]
@export var obstacle_difficulty: Array[float]

func get_random_environment() -> Texture2D:
	return environments.pick_random()

func get_random_obstacle(difficulty: int) -> Level:
	return obstacles.pick_random()
