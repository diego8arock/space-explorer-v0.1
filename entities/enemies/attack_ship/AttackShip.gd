extends KinematicBody2D

#Export
export var debug: bool = false
export var bullet: PackedScene
#debug
var d_draw_attack_range
var d_draw_follow_range
#OnReady
onready var n_muzzle_left = $Muzzles/MuzzleLeft
onready var n_muzzle_right = $Muzzles/MuzzleRight
onready var n_health = $Health
onready var n_fire_rate = $FireRate
onready var n_collider = $CollisionPolygon2D
onready var n_aim_target = $AimTarget
onready var n_steering = $Steering
onready var n_stats = $NPCStats
onready var n_movement = $Movement
#Members
var m_attack_groups = [Groups.PLAYER, Groups.ALLY]
var m_velocity: Vector2
var m_target: Node2D
var m_crowd = []
var m_leader: Node2D
var m_rotation_speed: float
var m_target_to_patrol: Vector2 = Vector2.ZERO
#Enum
enum STATE {IDLE, WANDER, FOLLOW_LEADER, ARRIVE_AT_TARGET, PURSUIT_TARGET, PATROL}
var m_current_state = STATE.IDLE

signal died(object)
signal request_random_ttm(object)

func _ready() -> void:
	
	Debug.add(name, debug)
	n_steering.debug = debug
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
	var objects = Functions.get_objects_from_groups([Groups.LEADER, Groups.ENEMY])
	if objects.size() == 1:
		m_leader = objects[0]
		m_current_state = STATE.FOLLOW_LEADER
	m_current_state = STATE.PATROL
	
	d_draw_attack_range = $AttackRange/CollisionShape2D.shape.radius
	d_draw_follow_range = $FollowRange/CollisionShape2D.shape.radius
	
func _draw() -> void:
	
	if debug:
		if d_draw_follow_range:
			draw_arc(Vector2.ZERO, d_draw_follow_range, deg2rad(0), deg2rad(360), 50, Color(0.9,0.7,0))
		if d_draw_attack_range:
			draw_arc(Vector2.ZERO, d_draw_attack_range, deg2rad(0), deg2rad(360), 50, Color(1,0,0))
		
func _process(_delta: float) -> void:
	
	if debug:
		update()

func _physics_process(delta: float) -> void:
	
	Debug.do(name, "STATE", STATE.keys()[m_current_state])

	match m_current_state:
		STATE.IDLE:
			pass
		STATE.WANDER:
			wander()
		STATE.FOLLOW_LEADER:
			follow_leader()
		STATE.ARRIVE_AT_TARGET:
			arrive_at_target()	
		STATE.PURSUIT_TARGET:
			pursuit_target()
		STATE.PATROL:
			patrol()

	Debug.do(name, "m_velocity", m_velocity)
	move_and_slide(m_velocity)
	global_rotation = n_steering.rotate_to(m_velocity, global_rotation, delta, m_rotation_speed)

func wander() -> void:
	
	m_velocity = n_steering.wander(
		m_velocity,
		n_movement.wander.cirlce_distance, 
		n_movement.wander.circle_radius,
		n_movement.wander.angle_change,
		n_movement.wander.max_speed,
		n_movement.wander.max_force,
		n_movement.wander.mass		
	)
	
	m_rotation_speed = n_movement.wander.rotation_speed
	
func follow_leader() -> void:
	
	if m_crowd.size() == 0:
		m_crowd = Functions.get_objects_from_groups([Groups.FOLLOWER, Groups.ENEMY])
		
	m_velocity = n_steering.follow(
		m_velocity, 
		m_leader.velocity, 
		m_leader.global_position, 
		global_position,
		m_crowd,
		self,
		n_movement.follow_leader.max_speed,
		n_movement.follow_leader.max_force,
		n_movement.follow_leader.mass,
		n_movement.follow_leader.arrival_distance,
		n_movement.follow_leader.follow_distance,
		n_movement.follow_leader.separation_radius,
		n_movement.follow_leader.max_separation
	)
	
	m_rotation_speed = n_movement.follow_leader.rotation_speed
	
func arrive_at_target() -> void:
	
	m_velocity = n_steering.arrive(		
		m_velocity, 
		m_target.global_position, 
		global_position,
		n_movement.arrive_at_target.max_speed,
		n_movement.arrive_at_target.max_force,
		n_movement.arrive_at_target.mass,
		n_movement.arrive_at_target.arrival_distance
		)
		
	m_rotation_speed = n_movement.arrive_at_target.rotation_speed
		
func pursuit_target() -> void:
	
	m_velocity = n_steering.pursuit(		
		m_velocity, 
		m_target.get_velocity(),
		m_target.global_position, 
		global_position,
		n_movement.pursuit_target.max_speed,
		n_movement.pursuit_target.max_force,
		n_movement.pursuit_target.mass
		)
		
	m_rotation_speed = n_movement.pursuit_target.rotation_speed
	
func patrol() -> void:
	
	if m_target_to_patrol == Vector2.ZERO:
		request_random_ttm()
	else:
		m_velocity = n_steering.arrive(		
			m_velocity, 
			m_target_to_patrol, 
			global_position,
			n_movement.arrive_at_target.max_speed,
			n_movement.arrive_at_target.max_force,
			n_movement.arrive_at_target.mass,
			n_movement.arrive_at_target.arrival_distance
			)
		
		m_rotation_speed = n_movement.arrive_at_target.rotation_speed
		
		if global_position.distance_to(m_target_to_patrol) < 100:
			m_target_to_patrol = Vector2.ZERO
	
func request_random_ttm() -> void:
	
	emit_signal("request_random_ttm", self)
	
func set_random_ttm(ttm) -> void:
	
	m_target_to_patrol = ttm

func take_damage(damage: float) -> void:
	
	Debug.do(name, "damage", damage)
	n_health.take_damage(damage)
	
func died() -> void:
	
	Debug.do(name, "died", "called")
	Functions.set_object_ready_for_queue_free(self, [n_collider], [n_fire_rate], "died")
	
func safe_delete() -> void:
	
	Debug.do(name, "safe_delete", "called")
	call_deferred("free")
	
func target_detected() -> void:
	
	n_aim_target.target_detected()
	
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

func _on_FollowRange_body_entered(body):
	
	if body.is_in_group(Groups.PLAYER) and not m_current_state == STATE.PURSUIT_TARGET:		
		m_target = body
		m_current_state = STATE.ARRIVE_AT_TARGET

func _on_AttackRange_body_entered(body: Node2D):
	
	if body.is_in_group(Groups.PLAYER):	
		assert(body.has_method("get_velocity"))	
		m_target = body
		m_current_state = STATE.PURSUIT_TARGET
		n_fire_rate.start()

func _on_AttackRange_body_exited(body: Node) -> void:
	
	if body == m_target:
		m_current_state = STATE.ARRIVE_AT_TARGET
		n_fire_rate.stop()

func _on_FollowRange_body_exited(body: Node) -> void:
	
	if body == m_target:
		m_target = null
		m_current_state = STATE.PATROL

