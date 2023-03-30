class_name InventorySlot extends TextureRect

@export var itemContainerPath:NodePath
@onready var itemContainer = get_node(itemContainerPath)

var item : Item

func _ready():
	if item:
		itemContainer.add_child(item)

func setItem(newItem):
	item = newItem

func pickItem():
	itemContainer.remove_child(item)
	item.pickItem()
	item = null
	
func putItem(newItem):
	item = newItem
	item.putItem()
	itemContainer.add_child(item)
