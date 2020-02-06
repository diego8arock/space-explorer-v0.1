extends KinematicBody2D

#Export
export var debug: bool = false
export var bullet: PackedScene
#OnReady
onready var n_muzzle_left = $Muzzles/MuzzleLeft
onready var n_muzzle_right = $Muzzles/MuzzleRight
onready var n_health = $Health
onready var n_fire_rate = $FireRate
onready var n_collider = $CollisionPolygon2D
onready var n_aim_target = $AimTarget
onready var n_steering = $Steering
onready var n_stats = $Stats
#Members
var m_attack_groups = [Groups.PLAYER, Groups.ALLY]
var m_velocity: Vector2
var m_target
var m_crowd = []
signal died(object)

func _ready() -> void:
	
	Debug.add(name, debug)
	add_to_group(Groups.ENEMY)	
	add_to_group(Groups.FOLLOWER)
	n_muzzle_left.set_attack_groups(m_attack_groups)
	n_muzzle_left.set_damage(n_stats.damage)
	n_muzzle_left.set_bullet(bullet)
	n_muzzle_right.set_attack_groups(m_attack_groups)
	n_muzzle_right.set_damage(n_stats.damage)
	n_muzzle_right.set_bullet(bullet)
	n_aim_target.target_not_detected()
	n_health.set_health(n_stats.health)
	m_target = Functions.get_objects_from_groups([Groups.LEADER, Groups.ENEMY])[0]
	global_position = m_target.global_position	

func _physics_process(delta: float) -> void:
	
	if m_crowd.size() == 0:
		m_crowd = Functions.get_objects_from_groups([Groups.FOLLOWER, Groups.ENEMY])
		
	m_velocity = n_steering.follow(
		m_velocity, 
		m_target.velocity, 
		m_target.global_position, 
		global_position,
		m_crowd,
		self,
		n_stats.max_speed,
		n_stats.max_force,
		n_stats.mass,
		n_stats.arrival_distance,
		n_stats.follow_distance,
		n_stats.separation_radius,
		n_stats.max_separation
	)	
		
	move_and_slide(m_velocity)
	global_rotation = n_steering.rotate_to(m_velocity, global_rotation, delta, n_stats.rotation_speed)
		
func take_damage(damage: float) -> void:
	
	Debug.do(name, "damage", damage)
	n_health.take_damage(damage)
	
func died() -> void:
	
	Debug.do(name, "died", "called")
	Functions.set_object_ready_for_queue_free(self, [n_collider], [n_fire_rate], "died")
	
func safe_delete() -> void:
	
	Debug.do(name, "safe_delete", "called")
	call_deferred("free")
	
func taget_detected() -> void:
	
	n_aim_target.taget_detected()
	
func target_not_detected() -> void:
	
	n_aim_target.target_not_detected()
	
func target_aimed() -> void:
	 
	n_aim_target.target_aimed()

func _on_FireRate_timeout() -> void:
	
	n_muzzle_left.shoot()
	n_muzzle_right.shoot()

func _on_SelectArea_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if event is InputEventScreenTouch:
		Events.emit_signal("target_selected", self)
		Debug.do(name, "_on_SelectArea_input_event", "touch")
		



