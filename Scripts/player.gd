class_name GunDisplay
extends Node2D

@export var guns: Array[Gun]
@export var bullet_display: PackedScene

var current_gun: int

@onready var bullets: Node2D = %Bullets
@onready var sprite: Sprite2D = $Sprite
@onready var shot_position: Node2D = $ShotPosition

func _ready() -> void:
	reset()

func reset() -> void:
	for gun in guns:
		gun.reset()

func shoot():
	if guns[current_gun].can_shoot():
		guns[current_gun].shoot()
		var bullet: BulletDisplay = bullet_display.instantiate()
		bullets.add_child(bullet)
		bullet.load_bullet(guns[current_gun].bullet.duplicate(true), shot_position.global_position, rotation)

func switch_gun_left():
	pass

func switch_gun_right():
	pass

func update_gun():
	sprite.texture = guns[current_gun].sprite
