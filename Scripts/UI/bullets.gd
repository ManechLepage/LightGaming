extends Control
@onready var label: Label = $Label


func load_quantity(value: int):
	label.text = str(value)
