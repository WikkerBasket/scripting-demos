extends KinematicBody2D

var onTile = Vector2()
var direction = Vector2.RIGHT
var speed = 350
var friction = 0.3

var dashDuration = 0.2
var dashSpeed = 900
var slideFriction = 0.08

var maxGravity = 1000

var jumpWeight = 5
var jumpHeight = 550
var shortHop = 250

var isCrouch = false
var isWalk = true
var canJump = true
var isJump = true

onready var dash = $Dash
onready var onGround = $onGround


func walk():
	if Input.is_action_pressed("left"):
		onTile.x = -speed
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		onTile.x = speed
		direction = Vector2.RIGHT
	else:
		onTile.x = lerp(onTile.x, 0, friction)
	onTile.x = clamp(onTile.x, -speed, speed)

func slide():
	if Input.is_action_pressed("down") && onGround.is_colliding() == true:
		isCrouch = true
		canJump = false
		if Input.is_action_just_pressed("jump") && direction == Vector2.LEFT && dash.canDash:
			isWalk = false
			dash.startDash(dashDuration)
			onTile.x = -dashSpeed
		elif Input.is_action_just_pressed("jump") && direction == Vector2.RIGHT && dash.canDash:
			isWalk = false
			dash.startDash(dashDuration)
			onTile.x = dashSpeed
		else:
			onTile.x = lerp(onTile.x, 0, slideFriction)
	else:
		canJump = true
		isWalk = true
		isCrouch = false
		

func jump():
	if Input.is_action_pressed("jump") && isJump == false: 
		isJump = true
		onTile.y = -jumpHeight
	if Input.is_action_just_released("jump"):
		if onTile.y < 0 && onTile.y < -shortHop:
			onTile.y += 300
	if onGround.is_colliding() == true && isJump == true:
		isJump = false
	if onGround.is_colliding() == false && isJump == true:
			onTile.y += jumpWeight

func _process(delta):
	if onGround.is_colliding() == true:
		onTile.y = 0
	else:
		onTile.y += delta * maxGravity
	onTile.y = clamp(onTile.y, -maxGravity, maxGravity)
	
	if canJump == true:
		jump()
	if isWalk == true:
		walk()
	
	slide()
	move_and_slide(onTile)



#func _ready():
	#pass 
