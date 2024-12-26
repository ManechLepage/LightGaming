class_name GunDisplay
extends Node2D

@export var gun: Gun
@export var bullet_display: PackedScene

var current_gun: int

@onready var bullets: Node2D = %Bullets
@onready var sprite: Sprite2D = $Sprite
@onready var shot_position: Node2D = $ShotPosition

func _ready() -> void:
	reset()

func reset() -> void:
	gun.reset()

func shoot():
	if gun.can_shoot():
		var bullet_resource: Bullet = gun.shoot()
		var bullet: BulletGraph = bullet_display.instantiate()
		bullets.add_child(bullet)
		bullet.load_bullet(gun.bullet.duplicate(true), shot_position.global_position, rotation)

func switch_gun_left():
	pass

func switch_gun_right():
	pass

func update_gun():
	sprite.texture = gun.sprite
