extends KinematicBody2D

enum STATE {ARRIVE, FLEE}
var state = STATE.ARRIVE
export var health: float = 3.0
onready var steering = $Steering
var velocity: Vector2
var angle_change: float
var target

signal died()

func _ready() -> void:
	
	randomize()
	angle_change = rand_range(30.0, 120.0)
	target = get_tree().get_nodes_in_group("gun")[0]

func _physics_process(delta: float) -> void:
	
	#velocity = steering.wander(velocity, 20.0, 10.0, angle_change)
	if state == STATE.ARRIVE:
		velocity = steering.arrive(velocity, target.global_position, global_position)
	if state == STATE.FLEE:
		velocity = steering.flee(velocity, target.global_position, global_position)
	var collision = move_and_collide(velocity)
			
func take_damage() -> void:
	
	health -= 1.0
	if health <= 0.0:
		emit_signal("died")
		
func safely_delete() -> void:
	
	remove_from_group("targets")
	visible = false
	$CollisionShape2D.disabled = true
	$Delete.start()

func _on_Delete_timeout() -> void:
	
	queue_free()

func _on_Flee_timeout() -> void:
	
	state = STATE.FLEE
