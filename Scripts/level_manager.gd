class_name LevelManager
extends Node

@onready var input_manager: InputManager = %InputManager
@onready var tile_manager: TileManager = %TileManager
@onready var environment_light: PointLight2D = %EnvironmentLight
@onready var gun: GunDisplay = %Gun
@onready var level_label: Label = %LevelLabel
@onready var next: TextureButton = %TextureButton
@onready var level: Node2D = %Level
@onready var game_ui: Control = %GameUI
@onready var color: ColorRect = %ColorRect
@onready var shop_1: Control = %Shop1
@onready var shop_2: Control = %Shop2
@onready var shop_3: Control = %Shop3
@onready var dark: CanvasModulate = %Darkness
@onready var next_level: Control = %NextLevel
@onready var button: Button = %Button
@onready var explosion: AudioStreamPlayer = %Explosion
@onready var money: AudioStreamPlayer = %Money
@onready var death_sound: AudioStreamPlayer = %Death
@onready var label: Label = %Label
@onready var bullet_destruction: AudioStreamPlayer = %BulletDestruction
@onready var audio_stream_player: AudioStreamPlayer = $"../Audio/AudioStreamPlayer"
@onready var audio_stream_player2: AudioStreamPlayer = $"../Audio/AudioStreamPlayer2"

var is_dead: bool = false


enum Difficulties {
	EASY,
	MEDIUM,
	HARD
}

var gear_quantity: int = 0
var bullet_quantity: int = 0

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
	GlobalValues.load_values()
	call_deferred("load_level")
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
	dark.visible = true
	death = false
	color.visible = false
	next_level.visible = false
	tile_manager.remove()

func win_level():
	tile_manager.turns = 1
	if tile_manager.Flamethrow.playing:
		tile_manager.Flamethrow.stop()
	if difficulty == 25:
		audio_stream_player.play()
		audio_stream_player2.play()
		dark.visible = false
		color.visible = true
		next_level.visible = true
		label.text = "You won!"
		button.text = "Endless mode"
	elif difficulty % 3 == 0:
		load_shop()
	else:
		load_level()
		
var death = false

func kill_player():
	death_sound.play()
	health -= 1
	if health == 0:
		is_dead = true
	hurt.emit()
	death = true
	dark.visible = false
	color.visible = true
	next_level.visible = true
	if is_dead:
		button.text = "Restart Game"
		label.text = "Game Over"
	elif difficulty % 3 == 0:
		button.text = "Enter Shop"
	elif difficulty == 25:
		button.text = "Endless mode"
		label.text = "You won!"
	else:
		button.text = "Next Level"

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
	money.play()
	current_buff = buff
	current_debuff = debuff

func apply_upgrade(index: int):
	gun.gun.initial_bullets[index] = Upgrades.apply_upgrade(gun.gun.initial_bullets[index], current_buff)
	if current_debuff:
		gun.gun.initial_bullets[index] = Upgrades.apply_upgrade(gun.gun.initial_bullets[index], current_debuff)

func _on_button_pressed() -> void:
	if is_dead:
		get_tree().reload_current_scene()
	win_level()
	if difficulty == 25:
		load_level()
		audio_stream_player.stop()
		audio_stream_player2.stop()
func explode():
	explosion.play()
