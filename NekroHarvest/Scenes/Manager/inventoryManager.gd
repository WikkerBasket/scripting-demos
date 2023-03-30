extends Node

@export var handPath:NodePath
@onready var itemHand = get_node(handPath)

@export var itemInfoPath:NodePath
@onready var itemInfo = get_node(itemInfoPath)

var inventories: Array = []
var itemInHand = null
var itemOffset = Vector2.ZERO

func _ready():
	SignalManager.inventoryReady.connect(self._on_inventory_ready)
	
func _on_inventory_ready(inventory):
	inventories.append(inventory)
	
	for slot in inventory.slots:
		slot.mouse_entered.connect(self._on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(self._on_mouse_exited_slot)
		slot.gui_input.connect(self._on_gui_input_slot.bind(slot))
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion and itemInHand:
		itemInHand.position = event.global_position - itemOffset

func _on_mouse_entered_slot(slot):
	if slot.item:
		itemInfo.display(slot)

func _on_mouse_exited_slot():
	itemInfo.hide()	

func _on_gui_input_slot(event: InputEvent, slot: InventorySlot):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if itemInHand:
			itemHand.remove_child(itemInHand)
			if slot.item:
				var temp_item = slot.item
				slot.pickItem()
				temp_item.global_position = event.global_position - itemOffset
				slot.putItem(itemInHand)
				itemInHand = temp_item
				itemHand.add_child(itemInHand)
			else:
				slot.putItem(itemInHand)
				itemInHand = null
		elif slot.item:
			itemInHand = slot.item
			itemOffset = event.global_position - itemInHand.global_position
			slot.pickItem()
			itemHand.add_child(itemInHand)
			itemInHand.position = event.global_position - itemOffset
