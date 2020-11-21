extends AcceptDialog
	
	
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
		get_node("ScrollContainer/VBoxContainer/Carte" + str(i)).texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".jpg")
		
	get_node(".").popup_centered()
