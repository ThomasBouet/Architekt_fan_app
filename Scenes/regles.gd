extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
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
		print(f)
		var text_rect = TextureRect.new()
		text_rect.name = f
		text_rect.texture = ResourceLoader.load("res://Sprites/livre-de-regles/" + f.split('.import')[0])
#		text_rect.expand = true
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		get_node("ScrollContainer/Content Holder").add_child(text_rect)
#		get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_" + str(i)).texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".jpg")
			
	dir.list_dir_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
