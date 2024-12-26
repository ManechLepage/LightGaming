class_name Gun
extends Resource


@export var name: String
@export var initial_bullets: Array[Bullet]
@export var sprite: Texture2D

var bullet_index: int = 0

var bullets: Array[Bullet]

func can_shoot() -> bool:
	if len(bullets) > 0:
		return true
	return false

func shoot() -> Bullet:
	bullets.remove_at(bullet_index)
	return bullets[bullet_index]

func reset() -> void:
	bullets = initial_bullets

func switch_left():
	bullet_index -= 1
	if bullet_index == -1:
		bullet_index = len(bullets) - 1

func switch_right():
	bullet_index += 1
	if bullet_index == len(bullets) - 1:
		bullet_index = 0
