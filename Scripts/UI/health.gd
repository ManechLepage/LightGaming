extends Control
@onready var tile: LevelManager = %LevelManager
func hurt():
	if not tile.death:
		get_child(0).get_child(-1).queue_free()
		tile.death = true
