class_name LevelManager
extends Node

@onready var tile_manager: TileManager = %TileManager
@onready var environment_light: PointLight2D = %EnvironmentLight

@onready var gun: GunDisplay = %Gun
@onready var level_label: Label = %LevelLabel

var gear_quantity: int = 0
var bullet_quantity: int = 0

var current_bullet_index = 0
var difficulty: int = 0
var health: int = 3

signal change_bullet(index: int)
signal update_gear(value: int)
signal update_bullets(value: int)
signal hurt

func _ready() -> void:
	load_level()
	update_gear.emit(gear_quantity)

func load_level() -> void:
	difficulty += 1
	level_label.text = "Level - " + str(difficulty)
	gun.reset()
	current_bullet_index = 0
	var level: Level = RandomLevel.get_random_obstacle()
	environment_light.texture = RandomLevel.get_random_environment()
	tile_manager.set_player(level.player_pos)
	tile_manager.load_obstacles(level)
	tile_manager.load_end_light()
	tile_manager.place_random_obstacles(difficulty)

func win_level():
	if difficulty % 3 == 0:
		print("LOAD SHOP")
	else:
		load_level()

func kill_player():
	health -= 1
	hurt.emit()
	win_level()


func _on_input_manager_switch_bullet_left() -> void:
	gun.switch_gun_left()

func _on_input_manager_switch_bullet_right() -> void:
	gun.switch_gun_right()

func add_gear():
	gear_quantity += 1
	update_gear.emit(gear_quantity)
