class_name Gun
extends Resource

@export var initial_bullet_quantity: int

var bullet_quantity: int
@export var name: String
@export var bullet: Bullet
@export var sprite: Texture2D


func can_shoot() -> bool:
	if bullet_quantity > 0:
		return true
	return false

func shoot() -> void:
	bullet_quantity -= 1

func reset() -> void:
	bullet_quantity = initial_bullet_quantity
