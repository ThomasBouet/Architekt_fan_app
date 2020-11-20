extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node(".").popup_centered()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
		print("ScrollContainer/VBoxContainer/Carte" + str(i))
		get_node("ScrollContainer/VBoxContainer/Carte" + str(i)).texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".jpg")
		
	get_node(".").popup_centered()
