class_name GunDisplay
extends Node2D

@export var gun: Gun
@export var bullet_display: PackedScene
@export var split_shot_bullet: Bullet
var current_gun: int
@onready var level_manager: LevelManager = %LevelManager
@onready var bullets: Node2D = %Bullets
@onready var sprite: Sprite2D = $Sprite
@onready var shot_position: Node2D = $ShotPosition
@onready var bullet_slots: Control = %BulletSlots
@onready var tile_manager: Node2D = %TileManager

signal load_bullets(bullets: Array[Bullet])
signal update_bullets(bullets: Array[Bullet])

func _ready() -> void:
	reset()

func reset() -> void:
	gun.reset()
	load_bullets.emit(gun.bullets)

func shoot():
	if not level_manager.death:
		if gun.can_shoot():
			var bullet_resource: Bullet = gun.shoot()
			if bullet_resource:
				var bullet: BulletGraph = bullet_display.instantiate()
				bullets.add_child(bullet)
				bullet.load_bullet(bullet_resource, shot_position.global_position, rotation)
				tile_manager.turns += 1
				tile_manager.flaming()
		update_bullets.emit(gun.bullets)

func switch_gun_left():
	if not level_manager.death:
		gun.switch_left()
		bullet_slots.select(gun.bullet_index)

func switch_gun_right():
	if not level_manager.death:
		gun.switch_right()
		bullet_slots.select(gun.bullet_index)

func update_gun():
	sprite.texture = gun.sprite

func generate_split_bullet(position: Vector2, index: int):
	var bullet: BulletGraph = bullet_display.instantiate()
	bullets.add_child(bullet)
	bullet.load_bullet(split_shot_bullet, position, index * PI / 3)

func get_bullet_quantity() -> int:
	return gun.get_bullet_quantity()
