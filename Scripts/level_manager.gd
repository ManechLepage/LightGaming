class_name LevelManager
extends Node

@onready var input_manager: InputManager = %InputManager
@onready var tile_manager: TileManager = %TileManager
@onready var environment_light: PointLight2D = %EnvironmentLight
@onready var color: ColorRect = %ColorRect
@onready var gun: GunDisplay = %Gun
@onready var level_label: Label = %LevelLabel
@onready var died_label: Label = %LabelD
@onready var level: Node2D = %Level
@onready var game_ui: Control = %GameUI
@onready var dark: CanvasModulate = %Darkness
@onready var shop_1: Control = %Shop1
@onready var shop_2: Control = %Shop2
@onready var shop_3: Control = %Shop3

enum Difficulties {
	EASY,
	MEDIUM,
	HARD
}

var gear_quantity: int = 2
var bullet_quantity: int = 2

var current_bullet_index = 0
var difficulty: int = 0
var health: int = 3

var current_buff: Upgrade
var current_debuff: Upgrade

var current_difficulty: Difficulties = Difficulties.MEDIUM

signal change_bullet(index: int)
signal update_gear(value: int)
signal update_bullets(value: int)
signal hurt

func _ready() -> void:
	load_level()
	update_gear.emit(gear_quantity)

func load_level() -> void:
	for l in tile_manager.lights:
		l.queue_free()
	tile_manager.lights.clear()
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
	died_label.visible = false
	color.visible = false
	
func win_level():
	tile_manager.turns = 1
	dark.visible = true
	death = false
	if difficulty % 3 == 0:
		load_shop()
	else:
		load_level()
var death = false
func kill_player():
	health -= 1
	hurt.emit()
	death = true
	dark.visible = false
	color.visible = true
	for l in tile_manager.lights:
		l.texture_scale /= 2
	died_label.visible = true
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
		shop_1.load_shop()
	elif shop_index == 2:
		shop_2.visible = true
		shop_2.load_shop()
	else:
		shop_3.visible = true
		shop_3.load_shop()


func quit_shop() -> void:
	input_manager.gameState = input_manager.GameState.ACTIVE
	shop_1.visible = false
	shop_2.visible = false
	shop_3.visible = false
	game_ui.visible = true
	level.visible = true
	
	load_level()

func set_upgrade(buff: Upgrade, debuff: Upgrade):
	current_buff = buff
	current_debuff = debuff

func apply_upgrade(index: int):
	gun.gun.initial_bullets[index] = Upgrades.apply_upgrade(gun.gun.initial_bullets[index], current_buff)
	if current_debuff:
		gun.gun.initial_bullets[index] = Upgrades.apply_upgrade(gun.gun.initial_bullets[index], current_debuff)
