extends Node2D
class_name Steering

export var debug = false

const DEFAULT_MASS: float = 2.0
const DEFAULT_MAX_VELOCITY_SPEED: float = 1.0
const DEFAULT_MAX_FORCE: float = 1.0
const DEFAULT_ROTATION_SPEED: float = 1.0
const DEFAULT_ARRIVAL_DISTANCE: float = 10.0
const DEFAULT_FOLLOW_DISTANCE: float = 200.0
const DEFAULT_SEPARATION_RADIUS: float = 10.0
const DEFAULT_MAX_SEPARATION: float = 10.0

var wander_angle: float = 0.0

var m_draw_seperation_radius
var m_draw_arrival_distance
var m_draw_follow_distance
var m_draw_max_separation
var m_draw_behind_position
var m_draw_future_target_position
var m_draw_circle_radius
var m_draw_circle_center
var m_draw_wander_force

func steer(velocity: Vector2, max_force: = DEFAULT_MAX_FORCE, mass: = DEFAULT_MASS) -> Vector2:

	var steering = velocity
	steering = steering.clamped(max_force)
	steering /= mass
	return steering

func seek(
		velocity: Vector2, 
		target_position: Vector2, 
		p_global_position: Vector2, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS
	) -> Vector2:

	var desired_velocity = (target_position - p_global_position).normalized() * max_velocity_speed
	var steering = steer(desired_velocity - velocity, max_force, mass)
	return (velocity + steering).clamped(max_velocity_speed)
	
func flee(
		velocity: Vector2, 
		target_position: Vector2, 
		p_global_position: Vector2, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS
	) -> Vector2:

	var desired_velocity = (p_global_position - target_position).normalized() * max_velocity_speed
	var steering = steer(desired_velocity - velocity, max_force, mass)
	return (velocity + steering).clamped(max_velocity_speed)
	
func arrive(		
		velocity: Vector2, 
		target_position: Vector2, 
		p_global_position: Vector2, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS,
		arrival_distance: float = DEFAULT_ARRIVAL_DISTANCE
	) -> Vector2:
	
	m_draw_arrival_distance = arrival_distance
	var desired_velocity = target_position - p_global_position
	var distance = desired_velocity.length()
	if distance < arrival_distance:
		desired_velocity = desired_velocity.normalized() * max_velocity_speed * (distance / arrival_distance)
	else:
		desired_velocity = desired_velocity.normalized() * max_velocity_speed
	var steering = steer(desired_velocity - velocity, max_force, mass)
	return (velocity + steering).clamped(max_velocity_speed)
	
func pursuit(
		velocity: Vector2, 
		target_velocity: Vector2,
		target_position: Vector2, 
		p_global_position: Vector2, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS
	) -> Vector2:

	var distance = target_position - p_global_position
	var T = distance.length() / max_velocity_speed
	var future_position = target_position + target_velocity * T
	m_draw_future_target_position = future_position
	return seek(velocity, future_position, p_global_position, max_velocity_speed, max_force, mass)
	
func evade(
		velocity: Vector2, 
		target_velocity: Vector2,
		target_position: Vector2, 
		p_global_position: Vector2, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS
	) -> Vector2:

	var distance = target_position - p_global_position
	var T = distance.length() / max_velocity_speed
	var future_position = target_position + target_velocity * T
	return flee(velocity, future_position, p_global_position, max_velocity_speed, max_force, mass)

func wander(
		velocity: Vector2, 
		cirlce_distance: float, 
		circle_radius: float, 
		angle_change: float, 
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS
	) -> Vector2:

	var circle_center: Vector2 = velocity
	circle_center = circle_center.normalized()
	circle_center *= cirlce_distance

	var displacement: Vector2 = Vector2(0, -1)
	displacement *= circle_radius

	var rad_wander_angle = deg2rad(wander_angle)
	var length = displacement.length()
	displacement.x = cos(rad_wander_angle) * length
	displacement.y = sin(rad_wander_angle) * length

	randomize()
	wander_angle += randf() * angle_change - angle_change * 0.5

	var wander_force: Vector2 = circle_center + displacement
	
	m_draw_circle_radius = circle_radius
	m_draw_circle_center = circle_center
	m_draw_wander_force = wander_force
	
	var steering = steer(wander_force, max_force, mass)
	return (velocity + steering).clamped(max_velocity_speed)	
	
func follow(
		velocity: Vector2, 
		target_velocity: Vector2, 
		target_position: Vector2, 
		p_global_position: Vector2,
		crowd, #array
		entity, #body
		max_velocity_speed: float = DEFAULT_MAX_VELOCITY_SPEED, 
		max_force: float = DEFAULT_MAX_FORCE, 
		mass: float = DEFAULT_MASS, 
		arrival_distance: float = DEFAULT_ARRIVAL_DISTANCE,
		follow_distance: float = DEFAULT_FOLLOW_DISTANCE,
		separtion_radius: float = DEFAULT_SEPARATION_RADIUS, 
		max_separation: float = DEFAULT_MAX_SEPARATION	
	) -> Vector2:
	
	m_draw_seperation_radius = separtion_radius
	m_draw_follow_distance = follow_distance
	m_draw_max_separation = max_separation	
	var tv: Vector2 = target_velocity * -1
	tv = tv.normalized() * follow_distance
	var behind_position = target_position + tv
	m_draw_behind_position = behind_position	
	var steering = arrive(velocity, behind_position, p_global_position, max_velocity_speed, max_force, mass, arrival_distance)
	steering += separation(crowd, entity, separtion_radius, max_separation)
	
	return steering
	
func separation(
		crowd, #array
		entity, #body
		separtion_radius: float = DEFAULT_SEPARATION_RADIUS, 
		max_separation: float = DEFAULT_MAX_SEPARATION
	) -> Vector2: 

	var force: Vector2 = Vector2.ZERO
	var neighbor_count: int = 0
	
	for cr in crowd:
		if cr != entity and cr.global_position.distance_to(entity.global_position) <= separtion_radius:
			force.x += cr.global_position.x - entity.global_position.x
			force.y += cr.global_position.y - entity.global_position.y
			neighbor_count += 1
			
	if neighbor_count != 0:
		force.x /= neighbor_count
		force.y /= neighbor_count
		force *= -1
		
	force = force.normalized() * max_separation

	return force
	
func rotate_to(
		velocity: Vector2, 
		global_rotation: float, 
		delta: float,
		rotation_speed: float = DEFAULT_ROTATION_SPEED		
	) -> float:
	
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	return current_direction.normalized().slerp(velocity.normalized(), rotation_speed * delta).angle()

func _draw() -> void:
	
	if debug:
		if m_draw_seperation_radius:
			draw_arc(Vector2.ZERO, m_draw_seperation_radius, deg2rad(0), deg2rad(360), 50, Color(1,1,1))
		if m_draw_follow_distance:
			draw_line(Vector2.ZERO, Vector2(m_draw_follow_distance,5), Color(0,1,0), 5.0)
		if m_draw_arrival_distance:
			draw_line(Vector2.ZERO, Vector2(m_draw_arrival_distance,-5), Color(0,0,1), 5.0)
		if m_draw_max_separation:
			draw_line(Vector2.ZERO, Vector2(0,m_draw_max_separation), Color(1,0,0), 5.0)
		if m_draw_behind_position:
			draw_circle(to_local(m_draw_behind_position), 10, Color(1,0,1))
		if m_draw_future_target_position:
			draw_circle(to_local(m_draw_future_target_position), 10, Color(0,1,1))
		if m_draw_circle_radius and m_draw_circle_center:
			draw_arc(m_draw_circle_center, m_draw_circle_radius, deg2rad(0), deg2rad(360), 50, Color(1,1,1))
		if m_draw_wander_force:
			draw_line(Vector2.ZERO, m_draw_wander_force, Color(1,0.7,0.5), 5.0)

func _process(_delta: float) -> void:
	
	if debug:
		update()
