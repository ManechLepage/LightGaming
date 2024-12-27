extends Control

@onready var label: Label = $Label
var gear_quantity: int

func _ready() -> void:
	pass

func load_quantity():
	label.text = str(gear_quantity)


func _on_level_manager_update_gear(value: int) -> void:
	gear_quantity = value
	call_deferred("load_quantity")
