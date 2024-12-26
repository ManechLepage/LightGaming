extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer
var bullets: Array[Bullet]
func _ready() -> void:
	select(0)

func select(index: int) -> void:
	for slot in h_box_container.get_children():
		slot.deselect()
	print(index)
	h_box_container.get_child(index).select()

func load_bullets():
	for i in range(h_box_container.get_child_count()):
		if bullets[i]:
			h_box_container.get_child(i).load_bullet(bullets[i])
		else:
			h_box_container.get_child(i).remove_bullet()

func _on_gun_load_bullets(_bullets: Array[Bullet]) -> void:
	bullets = _bullets
	call_deferred("load_bullets")

func _on_gun_update_bullets(_bullets: Array[Bullet]) -> void:
	bullets = _bullets
	load_bullets()
