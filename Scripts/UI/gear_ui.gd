extends Control

@onready var label: Label = $Label

func _ready() -> void:
	pass

func load_quantity(value: int):
	label.text = str(value)
