extends NinePatchRect

@export var inventoryContainerPath:NodePath
@onready var inventoryContainer = get_node(inventoryContainerPath)

@export var itemInfoPath:NodePath
@onready var itemInfo = get_node(itemInfoPath)

var currentInventory: Array = []

func _ready():
	SignalManager.inventoryOpened.connect(self._on_inventory_opened)
	SignalManager.inventoryClosed.connect(self._on_inventory_closed)

func close():
	for i in currentInventory:
		inventoryContainer.remove_child(i)
		
	currentInventory = []
	itemInfo.hide()
	hide()

func _on_inventory_opened(inventory:Inventory):
	if currentInventory.size() == 0:
		size.y = 35
	if currentInventory.has(inventory):
		return
	inventoryContainer.add_child(inventory)
	currentInventory.append(inventory)
	size.y += inventory.size.y - 5
	position.x = get_node("/root/GameScene/Main/Player").position.x + 50
	position.y = get_node("/root/GameScene/Main/Player").position.y - 500
	show()

func _on_exit_pressed():
	close()

func _on_inventory_closed():
	close()
