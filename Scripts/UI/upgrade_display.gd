extends Control

@onready var buff_label: Label = $Control/Buff
@onready var debuff_label: Label = $Control/Debuff
@onready var control: Control = $Control

@export var bullet_price: bool
@export var gear_price: bool

var buff: Upgrade
var debuff: Upgrade

signal buy
signal buy_upgrade(buff: Upgrade, debuff: Upgrade)

func load_item() -> void:
	var data = Upgrades.generate_upgrade()
	buff = data[0]
	if data.size() == 2:
		debuff = data[1]
	else:
		debuff = null
	load_upgrade()

func load_upgrade() -> void:
	buff_label.text = buff.name
	if debuff:
		debuff_label.text = debuff.name

func _on_texture_button_pressed() -> void:
	if Upgrades.buy(buff, debuff, bullet_price, gear_price):
		buy.emit()
		control.visible = false
		buy_upgrade.emit(buff, debuff)
