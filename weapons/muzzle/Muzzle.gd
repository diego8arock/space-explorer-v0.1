extends Position2D

export var bullet: PackedScene

var em_bullet_scale setget set_bullet_scale
var em_attack_groups setget set_attack_groups
var em_damage setget set_damage

func shoot() -> void:
	
	assert(em_attack_groups && em_attack_groups.size() > 0)
	assert(em_damage)
		
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(global_rotation)
	new_bullet.set_attack_groups(em_attack_groups)
	new_bullet.set_damage(em_damage)
	new_bullet.shoot(global_position, direction)	
	new_bullet.global_scale = global_scale
	get_tree().root.add_child(new_bullet)

func set_attack_groups(attack_groups = []) -> void:

	em_attack_groups = attack_groups
	
func set_bullet_scale(bullet_scale) -> void:
	
	em_bullet_scale = bullet_scale

func set_damage(damage: float) -> void:
	
	em_damage = damage
