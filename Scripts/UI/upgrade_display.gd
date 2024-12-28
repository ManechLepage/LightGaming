extends Control

@onready var buff_label: Label = $Control/Buff
@onready var debuff_label: Label = $Control/Debuff
@onready var control: Control = $Control

@export var bullet_price: bool
@export var gear_price: bool

var buff: Upgrade
var debuff: Upgrade

signal buy

func load_item() -> void:
	pass

func load_upgrade(_buff: Upgrade, _debuff: Upgrade) -> void:
	buff = _buff
	debuff = _debuff
	buff_label.text = buff.name
	if debuff:
		debuff_label.text = debuff.name

func _on_texture_button_pressed() -> void:
	if Upgrades.buy(buff, debuff, bullet_price, gear_price):
		buy.emit()
		control.visible = false
