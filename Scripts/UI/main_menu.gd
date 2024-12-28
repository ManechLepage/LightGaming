extends Control
@onready var level_manager: LevelManager = %LevelManager
@onready var input_manager: InputManager = %InputManager

func _on_button_pressed() -> void:
	visible = false
	input_manager.gameState = input_manager.GameState.ACTIVE
