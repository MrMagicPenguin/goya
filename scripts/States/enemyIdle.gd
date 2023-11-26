extends State
class_name enemyIdle

@export var enemy: CharacterBody3D
@export var moveSpeed: float

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.handleEnemyVision()
	if enemy.maxDetectionMeter:
		Transitioned.emit(self, "enemySuspicious")
