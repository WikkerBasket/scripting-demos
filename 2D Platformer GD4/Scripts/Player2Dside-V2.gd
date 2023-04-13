extends CharacterBody2D

@export var moveSpeed: float = 400
@export var slideSpeed: float  = 650
@export var jumpHeight: float = 200
@export var jumpTTPeak: float = 0.5
@export var jumpTTDescent: float = 0.4

@export var jumpBufferTime: float = 8
@export var coyoteTime: float = 0.2
@export var slideTime: float = 0.3
@export var cooldownTime: float = 0.3


@onready var jumpVelocity: float = ((2.0 * jumpHeight) / jumpTTPeak) * -1.0
@onready var jumpGravity: float = ((-2.0 * jumpHeight) / (jumpTTPeak * jumpTTPeak)) * -1.0
@onready var fallGravity: float = ((-2.0 * jumpHeight) / (jumpTTDescent * jumpTTDescent)) * -1.0


var direction = Vector2.RIGHT
var jumpBufferTimer: float
var coyoteTimer: float = 0.2
var slideTimer: float
var cooldownTimer: float

var done: bool = false

var canWalk = true
var canJump = false
var canCrouch = false
var canSlide = false

var isCrouching = false
var isJumping = false
var isSliding = false

func _process(delta):
	#apply gravity
	velocity.y += getGravity() * delta
	#checks for lawful jumping
	if is_on_floor() && !isCrouching:
		canWalk = true
	if !is_on_floor() && isJumping:
		canJump = false
	elif !is_on_floor() && !isJumping:
		canJump = true
		coyoteTimer -= delta
	if is_on_floor() && canWalk:
		walk()
	if canCrouch:
		crouch()
	if canSlide && isCrouching:
		slide()
	#jump logic with short hop and mid-air turnaround
	if Input.is_action_just_pressed("jump") && canJump:
		if coyoteTimer > 0:
			jump()
	elif Input.is_action_just_released("jump") && isJumping:
		if velocity.y < 0:
			velocity.y = (jumpGravity * delta)*0.75
	elif Input.is_action_just_pressed("left") && isJumping:
		velocity.x = lerpf(-moveSpeed/1.2, 0.5, delta)
	elif Input.is_action_just_pressed("right") && isJumping:
		velocity.x = lerpf(moveSpeed/1.2, 0.5, delta)
	#jump buffer
	if Input.is_action_just_pressed("jump") && !isCrouching:
		jumpBufferTimer = jumpBufferTime
	if jumpBufferTimer > 0 && velocity.y > 0:
		jumpBufferTimer -= 1
	if jumpBufferTimer > 0 && is_on_floor():
		jump()
		jumpBufferTimer = 0
	#slide mechanics
	if slideTimer > 0:
		slideTimer -= delta
	if isSliding && slideTimer > 0:
		canSlide = false
		isSliding = true
		if direction == Vector2.RIGHT:
			velocity.x = slideSpeed
		elif direction == Vector2.LEFT:
			velocity.x = -slideSpeed
	if slideTimer < 0:
		cooldown(delta)
		if cooldownTimer == 0:
			isSliding = false
			canSlide = true
			slideTimer = 0
		elif cooldownTimer > 0:
			canSlide = false
	
	set_up_direction(Vector2.UP)
	move_and_slide()
	print(canCrouch)

func walk():
	canJump = true
	canCrouch = true
	isJumping = false
	isCrouching = false
	coyoteTimer = coyoteTime
	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		velocity.x = -moveSpeed
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
		velocity.x = moveSpeed
		direction = Vector2.RIGHT
	else:
		velocity.x = lerpf(velocity.x, 0, 0.2)

func crouch():
	if Input.is_action_pressed("down") && canCrouch && is_on_floor():
		canWalk = false
		canJump = false
		canSlide = true
		isCrouching = true
		velocity.x = lerpf(velocity.x, 0, 0.2)
	elif Input.is_action_just_released("down"): 
		canWalk = true
		canJump = true
		canSlide = false
		isCrouching = false

func slide():
	if Input.is_action_just_pressed("jump") && !isSliding:
		isCrouching = true
		isSliding = true
		slideTimer = slideTime

func jump():
	canCrouch = false
	isJumping = true
	isCrouching = false
	velocity.y = jumpVelocity

func getGravity():
	return jumpGravity if velocity.y > 0 else fallGravity	

func cooldown(delta):
	if cooldownTimer == 0:
		cooldownTimer = cooldownTime
	if cooldownTimer > 0:
		cooldownTimer -= delta
	elif cooldownTimer < 0:
		cooldownTimer = 0
