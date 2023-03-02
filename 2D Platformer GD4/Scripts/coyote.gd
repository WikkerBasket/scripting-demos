extends Node2D

const coyoteDelay = 0.4

@onready var coyoteTimer = $CoyoteTimer
var canCoyote = true


func startCoyote(duration):
	if canCoyote == true:
		coyoteTimer.wait_time = duration
		coyoteTimer.start() 
	
func isCoyote():
	if !coyoteTimer.is_stopped():
		canCoyote = false
	return !coyoteTimer.is_stopped()

func _on_coyote_timer_timeout():
		canCoyote = true
