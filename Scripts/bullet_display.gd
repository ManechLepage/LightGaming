class_name BulletGraph
extends RigidBody2D

var bullet: Bullet
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var velocity: Vector2
var bounce_count: int

var last_velocity: Vector2

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	velocity = state.linear_velocity

func load_bullet(_bullet: Bullet, _position: Vector2, angle: float) -> void:
	bullet = _bullet
	sprite_2d.texture = bullet.sprite
	position = _position
	rotation = angle
	velocity = Vector2(cos(rotation), sin(rotation)) * bullet.speed * 25
	linear_velocity = velocity
	point_light_2d.scale = Vector2(bullet.size, bullet.size)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if bullet.bounce() or is_killed():
		queue_free()

func _physics_process(delta: float) -> void:
	last_velocity = linear_velocity

func is_killed() -> bool:
	var tile_position_offset: Vector2i
	if abs(last_velocity.x) > abs(last_velocity.y):
		if last_velocity.x > 0:
			tile_position_offset = Vector2i(1, 0)
		else:
			tile_position_offset = Vector2i(-1, 0)
	else:
		if last_velocity.y > 0:
			tile_position_offset = Vector2i(0, 1)
		else:
			tile_position_offset = Vector2i(0, -1)
	return GlobalValues.tile_manager.is_bullet_killed(position, tile_position_offset)
