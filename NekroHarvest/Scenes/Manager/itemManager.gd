extends Node

@onready var items = {
	#"tree" : preload()
}

func get_item(id:String):
	return items[id].instantiate()
	
