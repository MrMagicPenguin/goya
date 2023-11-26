extends Node
class_name EnemyState

signal Transitioned

@onready var enemy: CharacterBody3D = $"../.."
@export var moveSpeed: float

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
