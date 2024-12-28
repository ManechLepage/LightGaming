extends Node

var tile_manager: TileManager
var gun_manager: GunDisplay
var level_manager: LevelManager

func _ready() -> void:
	tile_manager = get_tree().get_first_node_in_group("Tile")
	gun_manager = get_tree().get_first_node_in_group("Gun")
	level_manager = get_tree().get_first_node_in_group("Level")
