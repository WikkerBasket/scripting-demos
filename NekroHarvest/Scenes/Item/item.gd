class_name Item extends TextureRect

@export var item_id:String
@export var item_name:String 

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func putItem():
	mouse_filter = Control.MOUSE_FILTER_PASS

