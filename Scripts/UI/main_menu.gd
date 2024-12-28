extends Control

@onready var level_manager: LevelManager = %LevelManager
@onready var input_manager: InputManager = %InputManager
@onready var difficulty: Button = $Menu/Difficulty
@onready var menu: Control = $Menu
@onready var tutorial: Control = $Tutorial

var first_time: bool = true

func _on_button_pressed() -> void:
	if not first_time:
		visible = false
		input_manager.gameState = input_manager.GameState.ACTIVE
	else:
		first_time = false
		tutorial.visible = true
		menu.visible = false

func _on_difficulty_pressed() -> void:
	if level_manager.current_difficulty == level_manager.Difficulties.MEDIUM:
		level_manager.current_difficulty = level_manager.Difficulties.HARD
		difficulty.text = "Difficulty: Hard"
	elif level_manager.current_difficulty == level_manager.Difficulties.EASY:
		level_manager.current_difficulty = level_manager.Difficulties.MEDIUM
		difficulty.text = "Difficulty: Medium"
	else:
		level_manager.current_difficulty = level_manager.Difficulties.EASY
		difficulty.text = "Difficulty: Easy"


func _on_continue_pressed() -> void:
	_on_button_pressed()
