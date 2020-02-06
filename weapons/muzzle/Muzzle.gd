extends Position2D

var em_bullet: PackedScene setget set_bullet
var em_bullet_scale: Vector2 setget set_bullet_scale
var em_attack_groups: Array setget set_attack_groups
var em_damage: float setget set_damage

func shoot() -> void:
	
	assert(em_attack_groups)
	assert(em_damage)
		
	var new_bullet = em_bullet.instance()
	var direction = Vector2(1, 0).rotated(global_rotation)
	new_bullet.set_attack_groups(em_attack_groups)
	new_bullet.set_damage(em_damage)
	new_bullet.shoot(global_position, direction)	
	new_bullet.global_scale = global_scale
	get_tree().root.add_child(new_bullet)

func set_bullet(bullet: PackedScene) -> void:
	
	em_bullet = bullet

func set_attack_groups(attack_groups: Array) -> void:

	em_attack_groups = attack_groups
	
func set_bullet_scale(bullet_scale: Vector2) -> void:
	
	em_bullet_scale = bullet_scale

func set_damage(damage: float) -> void:
	
	em_damage = damage
