extends KinematicBody2D



var onTile = Vector2()
var speed = 350
var friction = 0.3

var gravity = 1000
var jumpWeight = 5
var jumpHeight = 650
var shortHop = 250

var isJump = true
onready var onGround = $onGround


func walk():
	
	if Input.is_action_pressed("left"):
		onTile.x = -speed
	elif Input.is_action_pressed("right"):
		onTile.x = speed
	else:
		onTile.x = lerp(onTile.x, 0, friction)
	onTile.x = clamp(onTile.x, -speed, speed)
	move_and_slide(onTile, Vector2(0, -1))
		

func jump():
	if Input.is_action_pressed("jump") && isJump == false: 
		isJump = true
		onTile.y = -jumpHeight
	if Input.is_action_just_released("jump") && onTile.y < -shortHop:
		if onTile.y < 0:
			onTile.y += 350
	if onGround.is_colliding() == true && isJump == true:
		isJump = false
		
	if onGround.is_colliding() == false && isJump == true:
		onTile.y += jumpWeight

func _process(delta):
	onTile.y += delta * gravity
	var isMove = onTile * delta
	

	jump()
	walk()



#func _ready():
	#pass 
