extends Node

@export var buffs: Array[Upgrade]
@export var debuffs: Array[Upgrade]

func generate_upgrade() -> Array[Upgrade]:
	var upgrade: Array[Upgrade]
	
	upgrade.append(buffs.pick_random())
	if upgrade[0].rare:
		upgrade.append(debuffs.pick_random())
	
	return upgrade

func apply_upgrade(bullet: Bullet, upgrade: Upgrade) -> Bullet:
	var new_bullet: Bullet = bullet.duplicate(true)
	
	if upgrade.name == "+1 Bounce":
		new_bullet.max_bounce += 1
	elif upgrade.name == "Deadly Explosion":
		new_bullet.is_explosion_deadly = true
	elif upgrade.name == "+1 Explosion Range":
		new_bullet.explosion_range = max(0.8, new_bullet.explosion_range * 1.2)
	elif upgrade.name == "+2 Range":
		new_bullet.size *= 1.1
	elif upgrade.name == "-1 Range":
		new_bullet.size = max(0.1, new_bullet.size * 0.95)
	elif upgrade.name == "+2 Slowness":
		new_bullet.speed = max(0.2, new_bullet.speed * 0.8)
	elif upgrade.name == "+1 Speed":
		new_bullet.speed *= 1.1
	elif upgrade.name == "+1 Splitshot Bullet":
		new_bullet.split_quantity += 1
	
	return new_bullet

func buy(buff: Upgrade, debuff: Upgrade, bullets: bool, gears: bool) -> bool:
	if bullets:
		if GlobalValues.level_manager.bullet_quantity > 0:
			GlobalValues.level_manager.bullet_quantity -= 1
			GlobalValues.level_manager.update_bullets.emit(GlobalValues.level_manager.gear_quantity)
			return true
	if gears:
		if GlobalValues.level_manager.gear_quantity > 0:
			GlobalValues.level_manager.gear_quantity -= 1
			GlobalValues.level_manager.update_gear.emit(GlobalValues.level_manager.gear_quantity)
			return true
	else:
		return true
	return false
