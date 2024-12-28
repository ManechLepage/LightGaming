extends Control
@onready var label: Label = $Label
@onready var level_manager: LevelManager = %LevelManager
var quantity: int

func load_quantity():
	label.text = str(quantity)


func _on_level_manager_update_bullets(value: int) -> void:
	quantity = value
	call_deferred("load_quantity")
