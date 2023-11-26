extends EnemyState
class_name enemyIdle


func Enter():
	enemy.set_color(Color.BLUE)
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.handleEnemyVision()
	if enemy.detectionMeter >= enemy.maxDetectionMeter / 2:
		Transitioned.emit(self, "stateEnemySuspicious")
