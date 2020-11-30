extends AcceptDialog
	
	
func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))
	
func display_cards(p):	
	get_node(".").window_title = p["Nom"]
	
	var files = []
	var dir = Directory.new()
	dir.open("res://Sprites/Profils/" + p["Imgs"])
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".import"):
			files.append(file)
	
	dir.list_dir_end()
	
	for i in range(files.size()):
#		print("ScrollContainer/VBoxContainer/Carte" + str(i))
		var node = get_node("ScrollContainer/VBoxContainer/Carte" + str(i))
		node.texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".jpg")
		node.rect_min_size = Vector2(0,700)
	get_node(".").popup_centered()
