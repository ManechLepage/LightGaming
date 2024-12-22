extends Node2D

@export var initial_bullet_quantity: int
var bullet_quantity

func _ready() -> void:
	bullet_quantity = initial_bullet_quantity


func _process(delta: float) -> void:
	pass
