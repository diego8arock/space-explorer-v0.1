extends Node2D

var rotate_speed: float = 10.0
var bullet = preload("res://tests/gun/TestBullet.tscn")
onready var muzzle = $Muzzle
onready var get_target = $GetTarget
onready var fire_rate = $FireRate
var targets = []
var target

func _ready() -> void:
	
	get_target.start()

func _process(delta: float) -> void:
	
	if target:
		var target_direction = (target.global_position - global_position).normalized()
		var current_direction = Vector2.RIGHT.rotated(global_rotation)
		global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()

func shoot() -> void:
	
	var spread = rand_range(-10.0, 10.0)
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation + deg2rad(spread))
	new_bullet.shoot(muzzle.global_position, direction)	
	new_bullet.global_scale = global_scale
	get_tree().root.add_child(new_bullet)
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			shoot()		

func _on_GetTarget_timeout() -> void:
	
	acquire_target()
			
func acquire_target() -> void:	

	if !target: 
		if targets.size() > 0:
			target = targets[0]
			target.connect("died", self, "remove_target")
			fire_rate.start()		

func _on_FireRate_timeout() -> void:
	
	if target:
		shoot()
		fire_rate.start()
	
func remove_target() -> void:
	
	targets.erase(target)
	target.safely_delete()
	target = null
	acquire_target()

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	
	if body.is_in_group("targets"):
		targets.append(body)
		acquire_target()

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	
	if body.is_in_group("targets"):
		if targets.has(body):
			targets.erase(body)
			if body == target:
				target = null
				acquire_target()
