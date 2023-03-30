extends CharacterBody2D


@export var walkSpeed = 350.0

var canWalk = true
var isWalking = false

func _physics_process(_delta):
	if canWalk:
		walk()
	velocity = velocity.normalized() * walkSpeed
	move_and_slide()

func walk():
	var directionX = Input.get_axis("ui_left", "ui_right",)
	var directionY = Input.get_axis("ui_up","ui_down")
	
	if directionY:
		velocity.y = directionY * walkSpeed
		isWalking = true
	else: 
		velocity.y = move_toward(velocity.y, 0, walkSpeed)
	if directionX:
		velocity.x = directionX * walkSpeed
		isWalking = true
	else:
		velocity.x = move_toward(velocity.x, 0, walkSpeed)
	
	if velocity.y == 0 && velocity.x == 0:
		isWalking = false
	#correct animations:
	if directionX < 0:
		$Sprite2D.flip_h = true
	elif directionX > 0:
		$Sprite2D.flip_h = false
	#walking/idling
	if isWalking:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
	
