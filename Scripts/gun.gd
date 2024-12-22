class_name Gun
extends Resource

@export var initial_bullet_quantity: int

var bullet_quantity: int
@export var bullet: Bullet

func shoot() -> void:
	bullet_quantity -= 1

func reset() -> void:
	bullet_quantity = initial_bullet_quantity
