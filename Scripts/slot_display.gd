extends TextureRect

@onready var texture_rect: TextureRect = $TextureRect

@export var selected_texture: Texture2D
@export var deselected_texture: Texture2D

func load_bullet(bullet: Bullet) -> void:
	texture_rect.texture = bullet.sprite

func select() -> void:
	texture = selected_texture

func deselect() -> void:
	texture = deselected_texture

func remove_bullet() -> void:
	texture_rect.texture = null
