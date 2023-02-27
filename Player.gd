extends KinematicBody2D

var onTile = Vector2()
var speed = 250

var gravity = 200

var isJump = true
onready var onGround = $onGround


func walk():
	
	if Input.is_action_pressed("left"):
		onTile.x = -speed
	elif Input.is_action_pressed("right"):
		onTile.x = speed
	else:
		onTile.x = 0
	move_and_slide(onTile, Vector2(0, -1))
		

func jump():
	if Input.is_action_pressed("up") && isJump == false: 
		isJump = true
		onTile.y = -speed
	
	if onGround.is_colliding() == true && isJump == true:
		isJump = false

func _process(delta):
	onTile.y += delta * gravity
	var isMove = onTile * delta
	

	jump()
	walk()



#func _ready():
	#pass 
