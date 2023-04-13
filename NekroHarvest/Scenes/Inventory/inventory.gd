class_name Inventory extends NinePatchRect

@export var titlePath:NodePath
@onready var title = get_node(titlePath)

@export var slotPath:NodePath
@onready var slotContainer = get_node(slotPath)

@export var inventoryName:String
@export var inventorySize: int = 0: set = setInventorySize

var inventorySlot_res = preload("res://Scenes/Inventory/inventory_slot.tscn")
var slots: Array = []

func _ready():
	for s in slots:
		slotContainer.add_child(s)
		
	title.text = "-" + inventoryName + "-"
	SignalManager.inventoryReady.emit(self)

func setInventorySize(value):
	inventorySize = value
	custom_minimum_size.y += 85 + (ceil(inventorySize / 4.0) - 1) * 125
	
	for s in inventorySize:
		var newSlot = inventorySlot_res.instantiate()
		slots.append(newSlot)

func add_item(item):
	for s in slots:
		if not s.item:
			s.setItem(item)
			return
