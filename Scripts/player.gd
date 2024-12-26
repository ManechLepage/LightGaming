class_name GunDisplay
extends Node2D

@export var gun: Gun
@export var bullet_display: PackedScene

var current_gun: int

@onready var bullets: Node2D = %Bullets
@onready var sprite: Sprite2D = $Sprite
@onready var shot_position: Node2D = $ShotPosition
@onready var bullet_slots: Control = $"../CanvasLayer/GameUI/BulletSlots"

signal load_bullets(bullets: Array[Bullet])
signal update_bullets(bullets: Array[Bullet])

func _ready() -> void:
	reset()

func reset() -> void:
	gun.reset()
	load_bullets.emit(gun.bullets)

func shoot():
	if gun.can_shoot():
		var bullet_resource: Bullet = gun.shoot()
		if bullet_resource:
			var bullet: BulletGraph = bullet_display.instantiate()
			bullets.add_child(bullet)
			bullet.load_bullet(bullet_resource, shot_position.global_position, rotation)
	update_bullets.emit(gun.bullets)

func switch_gun_left():
	gun.switch_left()
	bullet_slots.select(gun.bullet_index)

func switch_gun_right():
	gun.switch_right()
	bullet_slots.select(gun.bullet_index)

func update_gun():
	sprite.texture = gun.sprite
