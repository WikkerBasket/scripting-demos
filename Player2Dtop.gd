extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var backstep = false

func walking():
	backstep = false
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("ui_right"):
		velocity = Vector2(0, speed).rotated(rotation)
	if Input.is_action_pressed("ui_left"):
		velocity = Vector2(0, -speed).rotated(rotation)
	if Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_up"):
		velocity = Vector2(speed, speed).rotated(rotation)
	if Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_down"):
		velocity = Vector2(-speed, speed).rotated(rotation)
	if Input.is_action_pressed("ui_left")  && Input.is_action_pressed("ui_up"):
		velocity = Vector2(speed, -speed).rotated(rotation)
	if Input.is_action_pressed("ui_left")  && Input.is_action_pressed("ui_down"):
		velocity = Vector2(-speed, -speed).rotated(rotation)
	velocity = velocity.normalized() * speed
	if position.distance_to(get_global_mouse_position()) < 3:
		velocity = Vector2(0, 0).rotated(rotation)

func _physics_process(_delta):
	walking()
	move_and_slide(velocity)
