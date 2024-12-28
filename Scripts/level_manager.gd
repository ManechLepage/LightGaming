class_name LevelManager
extends Node

@onready var input_manager: InputManager = %InputManager

@onready var tile_manager: TileManager = %TileManager
@onready var environment_light: PointLight2D = %EnvironmentLight

@onready var gun: GunDisplay = %Gun
@onready var level_label: Label = %LevelLabel

@onready var level: Node2D = %Level
@onready var game_ui: Control = %GameUI

@onready var shop_1: Control = %Shop1
@onready var shop_2: Control = %Shop2
@onready var shop_3: Control = %Shop3

var gear_quantity: int = 2
var bullet_quantity: int = 2

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
		load_shop()
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

func load_shop() -> void:
	input_manager.gameState = input_manager.GameState.MENU
	level.visible = false
	game_ui.visible = false
	var shop_index: int = randi_range(1, 3)
	if shop_index == 1:
		shop_1.visible = true
	elif shop_index == 2:
		shop_2.visible = true
	else:
		shop_3.visible = true

func quit_shop() -> void:
	input_manager.gameState = input_manager.GameState.ACTIVE
	shop_1.visible = false
	shop_2.visible = false
	shop_3.visible = false
	game_ui.visible = true
	level.visible = true
	
	load_level()
