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
#			TODO: Mettre un popup
			print("Déjà un héro dans la liste")
			return
		else:
			hashero = true
#	--- On autorise l'ajout que s'il l'on peut encore ajouter sans dépasser le seuil ---
	if currentPTS + int(p["Cout"]) <= maxPts:
		Team.append(p)
		currentPTS += int(p["Cout"])
		get_node("Content Holder/ProgressBar").value = currentPTS
		get_node("Content Holder/Panel").avg_stats(Team)
		
#		--- Gestion de l'atteinte du max de recrutement ---
		node.manage_recruitement(int(p["Max"]), int(node.get_child(4).text) + 1)
		
#		--- Gestion des mofications de recutement ---
		if Json.CHANGE_RECRUTEMENT.has(p["Imgs"]):
			var node_to_modify = Json.CHANGE_RECRUTEMENT[p["Imgs"]][0]
			var qty = Json.CHANGE_RECRUTEMENT[p["Imgs"]][1]
			var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
			if node_modified != null:
				var p_name = node_modified.get_child(1).get_child(0).text
				print(Json.profils_data[get_node("Faction").text].index(0))
				var p_max = qty + int("0")
				var p_qty = int(node_modified.get_child(4).text)
				node_modified.manage_recruitement(p_max, p_qty)
				
	else:
#		TODO: Mettre un popup
		print("seuil dépassé")
	
func remove_from_team(p, node):
	print("removing " + p["Nom"])
	if (p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste") and hashero:
		hashero = false
	Team.remove(Team.find(p))
	currentPTS -= int(p["Cout"])
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/Panel").avg_stats(Team)
#	--- Gestion de l'atteinte du min de recrutement ---
	node.manage_recruitement(int(p["Max"]), int(node.get_child(4).text) - 1)
	
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
	print("nombre d'imatges trouvées " + str(len(files)))
	
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
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for p in list:
		var profil = Profil.instance().init(p)
		profil.name = p["Imgs"]
		profil.get_child(1).connect("pressed", self, "show_cards", [p])
		profil.get_child(8).connect("pressed", self, "add_to_team", [p, profil])
		profil.get_child(9).connect("pressed", self, "remove_from_team", [p, profil])
		profil.get_child(9).visible = false
		profil.get_child(4).text = "0" 
		if p["Max"] == "0" or hide:
			profil.get_child(8).visible = false
		get_node("Content Holder/Profils/DiplayList").add_child(profil)
	
func _on_ProgressBar_value_changed(value):
	get_node("Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	pass # Replace with function body.
