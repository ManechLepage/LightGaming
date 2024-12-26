class_name InputManager
extends Node

signal shoot
signal switch_bullet_left
signal switch_bullet_right

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
	if Input.is_action_just_pressed("SwitchBulletLeft"):
		switch_bullet_left.emit()
	if Input.is_action_just_pressed("SwitchBulletRight"):
		switch_bullet_right.emit()
