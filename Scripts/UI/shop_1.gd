extends Control

@onready var items: Control = $Items
@onready var label: Label = $Label
@onready var level_manager: LevelManager = %LevelManager
@onready var apply_upgrade: Control = %ApplyUpgrade
@onready var shopkeep1: AnimatedSprite2D = %shopkeeper1
@onready var shopkeep2: AnimatedSprite2D = %shopkeeper2
func load_shop():
	for child in items.get_children():
		child.load_item()
	shopkeep2.play()

func hide_choices():
	items.visible = false
	label.visible = false
	apply_upgrade.visible = true

func show_choices():
	items.visible = true
	label.visible = true
	apply_upgrade.visible = false

func exit_shop():
	items.visible = true
	label.visible = true
	level_manager.quit_shop()


func _on_exit_button_pressed() -> void:
	exit_shop()


func _on_apply_upgrade_apply_upgrade(index: int) -> void:
	if visible:
		show_choices()
