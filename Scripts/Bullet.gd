class_name Bullet
extends Resource

@export var size: float = 1
@export var speed: float = 1

@export var max_bounce: int #-1 = no max

@export var sprite: Texture2D

@export var bullet_color: Color

var bounce_count: int

func bounce() -> bool:
	bounce_count += 1
	if bounce_count == max_bounce:
		return true
	return false
