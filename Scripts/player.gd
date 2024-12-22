class_name GunDisplay
extends Node2D

@export var guns: Array[Gun]
@export var bullet_display: PackedScene

var current_gun: int

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	for gun in guns:
		gun.reset()

func shoot():
	if guns[current_gun].can_shoot():
		guns[current_gun].shoot()

func switch_gun_left():
	pass

func switch_gun_right():
	pass

func update_gun():
	sprite.texture = guns[current_gun].sprite
