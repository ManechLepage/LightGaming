class_name BulletDisplay
extends Node2D

var bullet: Bullet
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func load_bullet(_bullet: Bullet) -> void:
	bullet = _bullet
	sprite_2d.texture = bullet.sprite
