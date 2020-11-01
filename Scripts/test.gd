extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var hashero = false
var maxPts = 180
var currentPTS = 0
var Team = []

func _ready():
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Panel").init()
	get_node("Content Holder/Panel").visible = false
	get_node("Content Holder/ProgressBar").visible = false
	refresh_profils_list(Json.load_all_factions(), true)
	
func add_to_team(p, node):
#	au moment de l'ajout, il faut:
#- vérifier que le profil fait parti des profils qui modifient la limite de recrutement
#-si oui, vérifier l'existence des profils affectés dans l'arbre
#-modifier les paramètres du Json
#-maj l'affichage
	print("adding " + p["Nom"])
	if p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
		if hashero:
			print("Déjà un héro dans la liste")
			return
		else:
			hashero = true
	if currentPTS + int(p["Cout"]) <= maxPts:
		Team.append(p)
		currentPTS += int(p["Cout"])
		get_node("Content Holder/ProgressBar").value = currentPTS
		get_node("Content Holder/Panel").avg_stats(Team)
		node.get_child(4).text = str(int(node.get_child(4).text) + 1)
		
#		--- Gestion de l'atteinte du max de recrutement ---
		node.get_child(4).visible =true
		node.get_child(9).visible = true
		if int(p["Max"]) == Team.count(p):
			node.get_child(8).visible = false
			node.get_child(5).visible = true
	else:
		print("seuil dépassé")
	
func remove_from_team(p, node):
	print("removing " + p["Nom"])
	Team.remove(Team.find(p))
	currentPTS -= int(p["Cout"])
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/Panel").avg_stats(Team)
	node.get_child(4).text = str(int(node.get_child(4).text) - 1)
	
#	--- Gestion de l'atteinte du min de recrutement ---
	node.get_child(8).visible = true
	if Team.count(p) == 0:
		node.get_child(9).visible = false
		node.get_child(4).visible = false
	
	if Team.count(p) != int(p["Max"]):
		node.get_child(5).visible = false
	
# --- Gestion de l'affichage des cartes ---
func show_cards(p):
	display_cards(p)
	var init_pos = get_node("ImgDisplay").position
	var target = Vector2(init_pos.x - 552, init_pos.y)
	get_node("ImgDisplay").move(target)

func display_cards(p):
	var files = []
	var dir = Directory.new()
	dir.open("res://Sprites/Profils/" + p["Imgs"])
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		print(file.get_basename())
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".import"):
			files.append(file)

	dir.list_dir_end()
	print()
	print("nombre d'imatges trouvées " + str(len(files)))
#	get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_0").texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/1.png")
	for i in range(len(files)):
		print("ImgDisplay/ScrollContainer/VBoxContainer/Carte_" + str(i))
		print("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".png")
		get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_" + str(i)).texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".png")

func _on_Close_pressed():
	var init_pos = get_node("ImgDisplay").position
	var target = Vector2(init_pos.x + 552, init_pos.y)
	get_node("ImgDisplay").move(target)
	get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_0").texture = null
	get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_1").texture = null
	get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_2").texture = null
	
# --- Gestion des boutons du menu --
func move_menu():
	var init_pos = get_node("Menu").position
	var target = Vector2(init_pos.x + (319 if !MenuOpen else -319), init_pos.y)
	get_node("Menu").move(target)
	MenuOpen = !MenuOpen
	
func _on_MenuBtn_pressed():
	move_menu()
	
func _on_Tous_pressed():
	Team = []
	hashero = false
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Panel").visible = false
	get_node("Content Holder/ProgressBar").visible = false
	refresh_profils_list(Json.load_all_factions(), true)
	move_menu()
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	Team = []
	hashero = false
	get_node("Faction").text = faction
	get_node("Content Holder/Panel").visible = true
	get_node("Content Holder/ProgressBar").visible = true
	refresh_profils_list(Json.profils_data[faction])
	move_menu()
	
func refresh_profils_list(list, hide=false):
	var node = get_node("Content Holder/Profils/DiplayList")
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	for p in list:
		var profil = Profil.instance().init(p)
		profil.get_child(1).connect("pressed", self, "show_cards", [p])
		profil.get_child(8).connect("pressed", self, "add_to_team", [p, profil])
		profil.get_child(9).connect("pressed", self, "remove_from_team", [p, profil])
		profil.get_child(9).visible = false
		profil.name = p["Imgs"]
		profil.get_child(4).text = "0" 
		if p["Max"] == "0" or hide:
			profil.get_child(8).visible = false
		get_node("Content Holder/Profils/DiplayList").add_child(profil)
	
func _on_ProgressBar_value_changed(value):
	get_node("Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	pass # Replace with function body.
