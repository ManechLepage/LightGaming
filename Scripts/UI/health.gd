extends Control

func hurt():
	get_child(0).get_child(-1).queue_free()
