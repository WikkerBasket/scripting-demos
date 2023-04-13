extends CharacterBody2D


@export var walkSpeed = 350.0
@export var bagName:String

var inventory:Inventory
var canWalk = true
var isWalking = false
var isInventory = false

func _physics_process(_delta):
	if canWalk:
		walk()
	velocity = velocity.normalized() * walkSpeed
	move_and_slide()
	
	if Input.is_action_just_pressed("Inventory") and isInventory == false:
		SignalManager.inventoryOpened.emit(inventory)
		isInventory = true
	elif Input.is_action_just_pressed("Inventory") and isInventory == true:
		SignalManager.inventoryClosed.emit()
		isInventory = false
	if isInventory == true:
		canWalk = false
		velocity.x = 0
		velocity.y = 0
	else:
		canWalk = true

func _init():
	inventory = preload("res://Scenes/Inventory/inventory.tscn").instantiate()

func _ready():
	inventory.inventoryName = bagName
	inventory.inventorySize = 12

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
	
