class_name RandomLevelGenerator
extends Node

@export var environments: Array[Texture2D]
@export var obstacles: Array[Level]

@export var obstacle_data: Array[Vector2i]
@export var obstacle_difficulty: Array[float]

func get_random_environment() -> Texture2D:
	return environments.pick_random()

func get_random_obstacle() -> Level:
	return obstacles.pick_random()

func get_random_tile(difficulty: int) -> Vector2i:
	var total_weight: float = 0.0
	var altered_weights: Array[float] = alter_weights(difficulty)
	for weight in altered_weights:
		total_weight+= weight
	
	var cumulative_weights: Array[float]
	var cumulative_sum: float = 0.0
	for weight in altered_weights:
		cumulative_sum += weight
		cumulative_weights.append(cumulative_sum)
	
	var random_value = randf() * total_weight
	for i in range(cumulative_weights.size()):
		if random_value <= cumulative_weights[i]:
			return obstacle_data[i]
	return Vector2.ZERO

func alter_weights(_difficulty: int) -> Array[float]:
	var difficulty = _difficulty/25
	var skewed_weights: Array[float]
	var total_weight = 0.0
	for i in range(obstacle_difficulty.size()):
		var reverse_index_factor: float = float(i + 1) / obstacle_difficulty.size()
		var adjusted_weight = lerp(obstacle_difficulty[i], reverse_index_factor * obstacle_difficulty.size(), difficulty)
		skewed_weights.append(adjusted_weight)
		total_weight += adjusted_weight
	
	return skewed_weights
