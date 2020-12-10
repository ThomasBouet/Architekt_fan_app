extends Control


func _ready():
	var files = []
	var dir = Directory.new()
	dir.open("res://Sprites/livre-de-regles")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".import"):
			files.append(file)
	dir.list_dir_end()

	for f in files:
		var text_rect = TextureRect.new()
		text_rect.name = f
		text_rect.texture = ResourceLoader.load("res://Sprites/livre-de-regles/" + f.split('.import')[0])
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		text_rect.rect_min_size = Vector2(0,700)
		get_node("ScrollContainer/DisplayList").add_child(text_rect)
	dir.list_dir_end()
