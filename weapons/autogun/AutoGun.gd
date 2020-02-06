extends Node2D

#Enums
enum CHARACTER { PLAYER, ENEMY, ALLY }
enum STATES { IDLE,  ATTACK }
#OnReady
onready var n_muzzle = $Muzzle
onready var n_fire_rate = $FireRate
#Internal Members
var m_rotate_speed: float = 10.0
var m_targets = []
var m_target
var m_current_state
var m_body_entered
var m_body_exited
#External Members
var em_attack_groups = [] setget set_attack_groups
var em_character setget set_character #enum
var em_damage: float setget set_damage
var em_spread_range: float = 0.0 setget set_spread_range
var em_fire_rate: float = 1.0 setget set_fire_rate
var em_bullet: PackedScene setget set_bullet

func _ready() -> void:
	
	Debug.add(name)
	m_current_state = STATES.IDLE

func _process(delta: float) -> void:
	
	Debug.do(name, "state", STATES.keys()[m_current_state])
	match m_current_state:
		STATES.IDLE:
			pass
		STATES.ATTACK:
			var target_direction = (m_target.global_position - global_position).normalized()
			var current_direction = Vector2.RIGHT.rotated(global_rotation)
			global_rotation = current_direction.linear_interpolate(target_direction, m_rotate_speed * delta).angle()

func shoot() -> void:
	
	assert(em_attack_groups && em_attack_groups.size() > 0)
		
	var spread = rand_range(-em_spread_range, em_spread_range)
	var new_bullet = em_bullet.instance()
	var direction = Vector2(1, 0).rotated(n_muzzle.global_rotation + deg2rad(spread))
	#Only player uses homing bullets
	if em_character == CHARACTER.PLAYER:
		new_bullet.set_target(m_target)
	new_bullet.set_attack_groups(em_attack_groups)
	new_bullet.set_damage(em_damage)
	new_bullet.shoot(n_muzzle.global_position, direction)	
	new_bullet.global_scale = $Gun.global_scale
	get_tree().root.add_child(new_bullet)
	
func target_detected() -> void:
	
	if Functions.is_object_in_any_group(m_body_entered, em_attack_groups):
		
		assert (m_body_entered.has_method("taget_detected"))
		assert (m_body_entered.has_method("target_not_detected"))
		assert (m_body_entered.has_method("target_aimed"))
		
		m_targets.append(m_body_entered)
		m_body_entered.taget_detected()
		acquire_target()
		
func target_lost() -> void:
	
	if Functions.is_object_in_any_group(m_body_exited, em_attack_groups):
		if m_targets.has(m_body_exited):
			m_targets.erase(m_body_exited)
			m_body_exited.target_not_detected()
			if m_body_exited == m_target:
				m_target = null
				acquire_target()
				
func acquire_target() -> void:	
	
	if m_targets.size() > 0:
		if not m_target:
			set_target(m_targets[0])
	else:
		n_fire_rate.stop()
		m_current_state = STATES.IDLE
		if em_character == CHARACTER.PLAYER:
			Events.emit_signal("player_auto_gun_target_lost")
			
func remove_target() -> void:
	
	m_targets.erase(m_target)
	m_target = null
	acquire_target()	
				
func set_target(body) -> void:
	
	m_target = body
	if not m_target.is_connected("died", self, "on_Target_died"):	
		m_target.connect("died", self, "on_Target_died")
	m_target.target_aimed()
	n_fire_rate.start()	
	m_current_state = STATES.ATTACK
	if em_character == CHARACTER.PLAYER:
		Events.emit_signal("player_auto_gun_set_target", m_target)
				
func force_set_target(body) -> void:
	
	Debug.do(name, "force_set_target", "called")
	if m_targets.has(body):
		if m_target:
			m_target.taget_detected()
		set_target(body)

#Events
func _on_FireRate_timeout() -> void:	
	
	shoot()
	n_fire_rate.start()
		
func _on_AttackRange_body_entered(body: PhysicsBody2D) -> void:
	
	m_body_entered = body
	target_detected()

func _on_AttackRange_body_exited(body: PhysicsBody2D) -> void:
	
	m_body_exited = body
	target_lost()
	
func on_Target_died(object) -> void:
	
	remove_target()	
			
#setters & getters
func set_attack_groups(attack_groups) -> void:

	em_attack_groups = attack_groups

func set_character(character) -> void:
	
	em_character = character
	
func set_damage(damage) -> void:
	
	em_damage = damage
	
func set_spread_range(spread_range: float) -> void:
	
	em_spread_range = spread_range
	
func set_fire_rate(fire_rate: float) -> void:
	
	em_fire_rate = fire_rate
	n_fire_rate.wait_time = em_fire_rate
	
func set_bullet(bullet: PackedScene) -> void:
	
	em_bullet = bullet
