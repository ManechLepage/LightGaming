extends Control

signal apply_upgrade(index: int)


func _on_button_pressed() -> void:
	apply_upgrade.emit(0)

func _on_button1_pressed() -> void:
	apply_upgrade.emit(1)

func _on_button2_pressed() -> void:
	apply_upgrade.emit(2)
