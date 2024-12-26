extends Node

var tile_manager: TileManager

func _ready() -> void:
	tile_manager = get_tree().get_first_node_in_group("Tile")
