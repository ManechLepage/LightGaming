extends Control

@onready var buff_label: Label = $Buff
@onready var debuff_label: Label = $Debuff

func load_upgrade(buff: Upgrade, debuff: Upgrade) -> void:
	buff_label.text = buff.name
	if debuff:
		debuff_label.text = debuff.name
