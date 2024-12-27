class_name LevelManager
extends Node

@onready var tile_manager: Node2D = $"../TileManager"
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var gun: GunDisplay = %Gun

@export var levels: Array[Level]
var gear_quantity: int = 0

var current_bullet_index = 0

signal change_bullet(index: int)
signal update_gear(value: int)

func _ready() -> void:
	load_level(levels[0])
	update_gear.emit(gear_quantity)

func load_level(level: Level) -> void:
	gun.reset()
	current_bullet_index = 0

func win_level():
	print("won level")

func kill_player():
	print("player killed")


func _on_input_manager_switch_bullet_left() -> void:
	gun.switch_gun_left()

func _on_input_manager_switch_bullet_right() -> void:
	gun.switch_gun_right()

func add_gear():
	gear_quantity += 1
	update_gear.emit(gear_quantity)
