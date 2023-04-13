class_name PlayerInventory extends NinePatchRect

@export var inventoryContainerPath:NodePath
@onready var inventoryContainer = get_node(inventoryContainerPath)

var currentInventory: Array = []

func _ready():
	SignalManager.inventoryOpened.connect(self._on_inventory_opened)
	SignalManager.inventoryClosed.connect(self._on_inventory_closed)

func close():
	for i in currentInventory:
		inventoryContainer.remove_child(i)
		
	currentInventory = []
	hide()

func _on_inventory_closed():
	close()

func _on_inventory_opened(inventory:Inventory):
	if currentInventory.size() == 0:
		size.y = 35
	if currentInventory.has(inventory):
		return
	inventoryContainer.add_child(inventory)
	currentInventory.append(inventory)
	size.y += inventory.size.y - 5
	position.x = 0
	position.y = 0 
	show()

func _on_exit_pressed():
	close()
