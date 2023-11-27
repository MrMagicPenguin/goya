extends EnemyState
class_name enemyPatrol


func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.moveToTarget(enemy.PatrolPoints[0])
	
