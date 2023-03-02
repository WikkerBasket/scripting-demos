extends CharacterBody2D

var onTile = Vector2()
var direction = Vector2.RIGHT
var speed = 350
var reverseSpeed = 200
var friction = 0.3

var dashDuration = 0.4
var dashSpeed = 450
var slideFriction = 0.08

var maxGravity = 1400

var jumpWeight = 10
var jumpHeight = 800
var jumpSpeed = 900
var shortHop = 400
var coyoteTime = 0.2

var isSlide = false
var isCrouch = false
var isWalk = true
var isJump = true
var canJump = true

@onready var dash = $Dash
@onready var onGround = $onGround
@onready var onCeiling = $onCeiling

func walk():
	canJump = true
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
		onTile.x = lerpf(onTile.x, 0, friction)
	onTile.x = clamp(onTile.x, -speed, speed)

func slide():
	if Input.is_action_pressed("down") && onGround.is_colliding():
		isCrouch = true
		canJump = false
		isWalk = false
		if Input.is_action_just_pressed("jump") && direction == Vector2.LEFT && dash.canDash && !dash.isDashing():
			dash.startDash(dashDuration)
			onTile.x = -dashSpeed
			isSlide = true
		elif Input.is_action_just_pressed("jump") && direction == Vector2.RIGHT && dash.canDash && !dash.isDashing():
			dash.startDash(dashDuration)
			onTile.x = dashSpeed
			isSlide = true
		elif Input.is_action_pressed("jump") && isSlide == true:
			slideBoost()
		else:
			onTile.x = lerpf(onTile.x, 0, slideFriction)
			isSlide = false
	elif Input.is_action_pressed("down") && !onGround.is_colliding():
		canJump = false
	else:
		isWalk = true
		isCrouch = false

func slideBoost():
	if direction == Vector2.RIGHT:
		onTile.x = dashSpeed
		onTile.y = -shortHop*1.2
	if direction == Vector2.LEFT:
		onTile.x = -dashSpeed
		onTile.y = -shortHop*1.2
	isSlide = false

func coyoteJump():
	await get_tree().create_timer(coyoteTime).timeout
	isJump = true

func jump():
	if Input.is_action_pressed("jump"): 
		if isJump == false:
			isJump = true
			onTile.y = -jumpHeight
	elif Input.is_action_just_released("jump"):
		if onTile.y < 0 && onTile.y < -shortHop:
			onTile.y += 300
	#Check for collisions
	if !onGround.is_colliding() && isJump == false:
		coyoteJump()
	if onGround.is_colliding() && isJump == true:
		isJump = false
	if onGround.is_colliding() == false && isJump == true:
		onTile.y += jumpWeight
	if onCeiling.is_colliding() && isJump == true:
		onTile.y = shortHop

func _process(delta):
	if is_on_floor() == true:
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
	
	print(onTile.y)
	set_velocity(onTile)
	set_up_direction(Vector2.UP)
	move_and_slide()

