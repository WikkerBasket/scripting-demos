extends CharacterBody2D

var onTile = Vector2()
var direction = Vector2.RIGHT
var speed = 350
var reverseSpeed = 200
var friction = 0.2

var dashDuration = 0.1
var dashSpeed = 600
var slideFriction = 0.05

var maxGravity = 1400

var jumpWeight = 10
var jumpHeight = 800
var jumpSpeed = 900
var shortHop = 350

var isCrouch = false
var isWalk = true
var isJump = true
var canJump = true

@onready var dash = $Dash
@onready var onGround = $onGround

func walk():
	if Input.is_action_pressed("left") && onGround.is_colliding():
		onTile.x = -speed
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right") && onGround.is_colliding():
		onTile.x = speed
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("left") && direction == Vector2.LEFT && onGround.is_colliding() == false:
		onTile.x = -jumpSpeed
	elif Input.is_action_pressed("right") && direction == Vector2.LEFT && onGround.is_colliding() == false:
		onTile.x = reverseSpeed
	elif Input.is_action_pressed("right") && direction == Vector2.RIGHT && onGround.is_colliding() == false:
		onTile.x = jumpSpeed
	elif Input.is_action_pressed("left") && direction == Vector2.RIGHT && onGround.is_colliding() == false:
		onTile.x = -reverseSpeed
	else:
		onTile.x = lerpf( onTile.x, 0, friction)
	onTile.x = clamp(onTile.x, -speed, speed)

func slide():
	if Input.is_action_pressed("down") && onGround.is_colliding() == true:
		isCrouch = true
		canJump = false
		isWalk = false
		if Input.is_action_just_pressed("jump") && direction == Vector2.LEFT && dash.canDash && !dash.isDashing():
			dash.startDash(dashDuration)
			onTile.x = -dashSpeed
		elif Input.is_action_just_pressed("jump") && direction == Vector2.RIGHT && dash.canDash && !dash.isDashing():
			dash.startDash(dashDuration)
			onTile.x = dashSpeed
		else:
			onTile .x = lerpf(onTile.x, 0, slideFriction)
	else:
		canJump = true
		isWalk = true
		isCrouch = false

func jump():
	if Input.is_action_pressed("jump") && isJump == false: 
		isJump = true
		onTile.y = -jumpHeight
	elif Input.is_action_just_released("jump"):
		if onTile.y < 0 && onTile.y < -shortHop:
			onTile.y += 300
	#Check for gounded collisions
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

	if isWalk == true:
		walk()
	if !dash.isDashing():
		slide()
	if canJump == true:
		jump()
	set_velocity(onTile)
	set_up_direction(Vector2.UP)
	move_and_slide()
	onTile = velocity
