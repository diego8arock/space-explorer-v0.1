extends Node2D

#Export
export var bullet: PackedScene
#Enums
enum CHARACTER { PLAYER, ENEMY, ALLY }
enum STATES { IDLE,  ATTACK }
#OnReady
onready var muzzle = $Muzzle
onready var get_target = $GetTarget
onready var fire_rate = $FireRate
#Internal Members
var rotate_speed: float = 10.0
var targets = []
var target
var current_state
var body_entered
var body_exited
#External Members
var em_attack_groups = [] setget set_attack_groups
var em_character setget set_character
var em_damage setget set_damage

func _ready() -> void:
	
	Debug.add(name)
	get_target.start()
	current_state = STATES.IDLE

func _process(delta: float) -> void:
	
	Debug.do(name, "state", STATES.keys()[current_state])
	match current_state:
		STATES.IDLE:
			pass
		STATES.ATTACK:
			var target_direction = (target.global_position - global_position).normalized()
			var current_direction = Vector2.RIGHT.rotated(global_rotation)
			global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()

func shoot() -> void:
	
	assert(em_attack_groups && em_attack_groups.size() > 0)
		
	var spread = rand_range(-10.0, 10.0)
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation + deg2rad(spread))
	new_bullet.set_attack_groups(em_attack_groups)
	new_bullet.set_damage(em_damage)
	new_bullet.shoot(muzzle.global_position, direction)	
	new_bullet.global_scale = $Gun.global_scale
	get_tree().root.add_child(new_bullet)

func acquire_target() -> void:	
	
	if targets.size() > 0:
		target = targets[0]
		target.connect("died", self, "on_Target_died")
		fire_rate.start()	
		current_state = STATES.ATTACK
	else:
		fire_rate.stop()
		current_state = STATES.IDLE
			
func remove_target() -> void:
	
	targets.erase(target)
	target = null
	acquire_target()	
	
func target_detected() -> void:
	
	if Functions.is_object_in_any_group(body_entered, em_attack_groups):
		targets.append(body_entered)
		acquire_target()
		
func target_lost() -> void:
	
	if Functions.is_object_in_any_group(body_exited, em_attack_groups):
		if targets.has(body_exited):
			targets.erase(body_exited)
			if body_exited == target:
				target = null
				acquire_target()

#Events
func _on_GetTarget_timeout() -> void:
	
	acquire_target()
	
func _on_FireRate_timeout() -> void:	
	
	shoot()
	fire_rate.start()
		
func _on_AttackRange_body_entered(body: PhysicsBody2D) -> void:
	
	body_entered = body
	if not target:
		target_detected()

func _on_AttackRange_body_exited(body: PhysicsBody2D) -> void:
	
	body_exited = body
	target_lost()
	
func on_Target_died() -> void:
	
	remove_target()	
			
#setters & getters
func set_attack_groups(attack_groups) -> void:

	em_attack_groups = attack_groups

func set_character(character) -> void:
	
	em_character = character
	
func set_damage(damage) -> void:
	
	em_damage = damage
