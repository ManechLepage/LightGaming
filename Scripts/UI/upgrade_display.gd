extends Control

@onready var buff_label: Label = $Control/Buff
@onready var debuff_label: Label = $Control/Debuff
@onready var control: Control = $Control

@export var bullet_price: bool
@export var gear_price: bool

var buff: Upgrade
var debuff: Upgrade

signal buy
signal apply_upgrade(buff: Upgrade, debuff: Upgrade)

func load_item() -> void:
	var data = Upgrades.generate_upgrade()
	buff = data[0]
	if data.size() > 1:
		debuff = data[2]
	load_upgrade()

func load_upgrade() -> void:
	buff_label.text = buff.name
	if debuff:
		debuff_label.text = debuff.name

func _on_texture_button_pressed() -> void:
	if Upgrades.buy(buff, debuff, bullet_price, gear_price):
		buy.emit()
		apply_upgrade.emit(buff, debuff)
		control.visible = false
