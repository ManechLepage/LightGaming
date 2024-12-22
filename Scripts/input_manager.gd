class_name InputManager
extends Node

signal shoot

enum GameState {
	ACTIVE,
	PASSIVE,
	MENU
}

var gameState: GameState

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left Click"):
		if gameState == GameState.ACTIVE:
			shoot.emit()
