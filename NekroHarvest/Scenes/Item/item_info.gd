extends NinePatchRect

@export var itemNamePath:NodePath
@onready var itemName = get_node(itemNamePath)

func display(slot:InventorySlot):
	position = slot.size + slot.global_position
	itemName.text = slot.item.item_name
	show()
