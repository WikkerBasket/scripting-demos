extends Button

@export var amount: int = 1
@export var chestName: String

var inventory : Inventory

func _init():
	inventory = preload("res://Scenes/Inventory/inventory.tscn").instantiate()

func _ready():
	inventory.inventorySize = amount
	inventory.inventoryName = chestName
	inventory.add_item(load("res://Scenes/Item/Data/item.tscn").instantiate())


func _on_pressed():
		SignalManager.inventoryOpened.emit(inventory)
		print(inventory.slots)
