extends Control

@onready var upgrade: Control = $Upgrade
@onready var apply_upgrade: Control = %ApplyUpgrade
@onready var level_manager: LevelManager = %LevelManager
@onready var shopkeep: AnimatedSprite2D = %shopkeeper3
func load_shop():
	shopkeep.play()
	upgrade.load_item()

func hide_choices():
	upgrade.visible = false
	apply_upgrade.visible = true

func show_choices():
	upgrade.visible = true
	apply_upgrade.visible = false

func exit_shop():
	upgrade.visible = true
	level_manager.quit_shop()


func _on_exit_button_pressed() -> void:
	exit_shop()


func _on_apply_upgrade_apply_upgrade(index: int) -> void:
	if visible:
		show_choices()
