extends EnemyState
class_name enemySearching


func Enter():
	enemy.set_color(Color.RED)
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.handleEnemyVision()
	enemy.lookAtTarget()
	enemy.moveToTarget()
	if enemy.detectionMeter <= enemy.maxDetectionMeter / 2:
		Transitioned.emit(self, "stateEnemySuspicious")
