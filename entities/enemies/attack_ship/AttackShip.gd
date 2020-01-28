extends KinematicBody2D

onready var muzzle_left = $Muzzles/MuzzleLeft
onready var muzzle_right = $Muzzles/MuzzleRight

var attack_groups = [Groups.PLAYER, Groups.ALLY]

signal died()

func _ready() -> void:
	
	Debug.add(name, true)
	add_to_group(Groups.ENEMY)	
	muzzle_left.set_attack_groups(attack_groups)
	muzzle_right.set_attack_groups(attack_groups)
	
func take_damage() -> void:
	
	Debug.do(name, "damage", 10)

func _on_FireRate_timeout() -> void:
	
	muzzle_left.shoot()
	muzzle_right.shoot()
