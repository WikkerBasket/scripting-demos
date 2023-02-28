extends Node2D

const dashDelay = 0.4

onready var dashTimer = $DashTimer
var canDash = true

func startDash(duration):
	dashTimer.wait_time = duration
	dashTimer.start()
	
func isDashing():
	return !dashTimer.is_stopped()

func endDash():
	canDash = false
	yield(get_tree().create_timer(dashDelay), "timeout")
	canDash = true

func _on_DashTimer_timeout():
	endDash()
