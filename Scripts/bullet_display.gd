class_name BulletDisplay
extends RigidBody2D

var bullet: Bullet
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var velocity: Vector2

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	velocity = state.linear_velocity

func load_bullet(_bullet: Bullet, _position: Vector2, angle: float) -> void:
	bullet = _bullet
	sprite_2d.texture = bullet.sprite
	position = _position
	rotation = angle
	velocity = Vector2(cos(rotation), sin(rotation)) * bullet.speed * 15
	linear_velocity = velocity
