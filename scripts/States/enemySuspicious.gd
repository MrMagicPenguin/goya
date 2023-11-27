extends EnemyState
class_name enemySuspicious


func Enter():
	enemy.set_color(Color.YELLOW)
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.handleEnemyVision()
	enemy.lookAtTarget()
	if enemy.detectionMeter >= enemy.maxDetectionMeter:
		Transitioned.emit(self, "stateEnemySearching")
	if enemy.detectionMeter <= 0:
		Transitioned.emit(self, "stateEnemyIdle")
