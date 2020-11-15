extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var hashero = false
var maxPts = 180
var currentPTS = 0
var teams = Json.get_team_saved()
var cur_team = []
var Team = []

func _ready():
	get_node("MesListes").text = "Mes Listes"
	get_node("Content/Content Holder/Panel").init()
	get_node("Content/Content Holder/Panel").visible = false
	get_node("Content/Content Holder/ProgressBar").visible = false
	
	get_node("AcceptDialog").add_cancel("Annuler")
	fill_list_menu()
	
func fill_list_menu():
	for t in teams:
		var nom = t.split(".json")[0]
		get_node("Content/MenuButton").get_popup().add_item(nom)
	get_node("Content/MenuButton").get_popup().connect("id_pressed", self, "display_team")
	
func _on_Delete_pressed(id):
	get_node("AcceptDialog").dialog_text = "Etes vous sur de vouloir supprimer l'équipe " + teams[id].split(".json")[0] + "?"
	get_node("AcceptDialog").popup_centered()
	get_node("AcceptDialog").connect("confirmed", self, "_on_AcceptDialog_confirmed", [id])
	
func clean_list_diplay():
	var node = get_node("Content/Content Holder/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	get_node("Content/Content Holder/Panel").visible = false
	get_node("Content/Content Holder/ProgressBar").visible = false
	
func _on_AcceptDialog_confirmed(id):
	var nom = teams[id]
	teams.remove(nom)
	get_node("Content/MenuButton").get_popup().clear()
	clean_list_diplay()
	var dir = Directory.new()
	dir.remove("user://" + nom)
	
	fill_list_menu()
	get_node("Content/Faction").text = ""
	get_node("Delete").visible = false
	if Json.get_team_saved() == []:
		_on_Accueil_pressed()
	
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
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".import"):
			files.append(file)
			
	dir.list_dir_end()
	
	for i in range(len(files)):
		get_node("ImgDisplay/ScrollContainer/VBoxContainer/Carte_" + str(i)).texture = ResourceLoader.load("res://Sprites/Profils/" + p["Imgs"] + "/" + str(i) + ".jpg")
	
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
	
func display_team(id):
	print(id)
	cur_team = teams[id]
	var team_faction = Json.get_team(cur_team)[0]
	var team_members = Json.get_team(cur_team)[1]
	
	get_node("Content/Faction").visible = true
	get_node("Content/Faction").text = team_faction
	get_node("Content/Content Holder/Panel").visible = true
	get_node("Content/Content Holder/ProgressBar").visible = true
	get_node("Content/Content Holder").visible = true
	get_node("Delete").visible = true
	get_node("Delete/DeleteButton").disconnect("pressed", self, "_on_Delete_pressed")
	get_node("Delete/DeleteButton").connect("pressed", self, "_on_Delete_pressed", [id])
	
	refresh_profils_list(Json.profils_data[team_faction])
	recreate_list(team_members)
	
	get_node("Save/SaveButton").disconnect("pressed", self, "save")
	get_node("Save/SaveButton").connect("pressed", self, "save", [id])
	
	get_node("Button").connect("pressed", self, "export_test", [Json.get_team(cur_team)])
	
func refresh_profils_list(list):
	var node = get_node("Content/Content Holder/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for p in list:
		var profil = Profil.instance().init(p)
		profil.name = p["Imgs"]
		profil.get_child(2).connect("pressed", self, "show_cards", [p])
		profil.get_child(9).connect("pressed", self, "add_to_team", [p, profil])
		profil.get_child(10).connect("pressed", self, "remove_from_team", [p, profil])
		profil.get_child(10).visible = false
		
		if p["Type"] == "Troupe":
			profil.get_child(1).texture = ResourceLoader.load("res://Sprites/UI/sword_01c.png")
			profil.get_child(0).color = "#7d653d"
		elif p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			profil.get_child(1).texture = ResourceLoader.load("res://Sprites/UI/helmet_02d.png")
			profil.get_child(0).color = "#551a1a"
		elif p["Type"] == "Alchimiste":
			profil.get_child(1).texture = ResourceLoader.load("res://Sprites/UI/potion_03c.png")
			profil.get_child(0).color = "#26621a"
		elif p["Type"] == "Special" or p["Type"] == "Spécial":
			profil.get_child(1).texture = ResourceLoader.load("res://Sprites/UI/cookie_01a.png")
			profil.get_child(0).color = "#3d777d"
			
		get_node("Content/Content Holder/Profils/DiplayList").add_child(profil)
		
		profil.get_child(5).text = "0" 
		if p["Max"] == "0":
			profil.get_child(9).visible = false
	#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	get_node("Content/Content Holder/Profils/DiplayList").add_child(c)
	
func recreate_list(list):
	var hero = null

	for p in list:
		if p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			hero = p
	get_node("Content/Content Holder/Profils/DiplayList/" + hero["Imgs"]).get_child(9).emit_signal("pressed")
	list.erase(hero)
	for p in list:
		print(p["Nom"])
		get_node("Content/Content Holder/Profils/DiplayList/" + p["Imgs"]).get_child(9).emit_signal("pressed")
	
func _on_ProgressBar_value_changed(value):
	get_node("Content/Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	
func _on_Accueil_pressed():
	get_tree().change_scene("res://Scenes/Accueil.tscn")
	
func add_to_team(p, node):
	print("adding " + node.profil["Nom"])
	if node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste":
		if hashero:
#			TODO: Mettre un popup
			show_message("Ajout impossible", "Un héros se trouve déjà dans votre liste.\nVous ne pouvez avoir qu'un seul héro par liste.")
			return
		else:
			hashero = true
#			get_node("Save").visible = true
#	--- On autorise l'ajout que s'il l'on peut encore ajouter sans dépasser le seuil ---
	if currentPTS + int(node.profil["Cout"]) <= maxPts:
		Team.append(p)
		currentPTS += int(node.profil["Cout"])
		get_node("Content/Content Holder/ProgressBar").value = currentPTS
		get_node("Content/Content Holder/Panel").avg_stats(Team)
		
#		--- Gestion de l'atteinte du max de recrutement ---
		node.manage_recruitement(node.get_recuitement() + 1)
		
#		--- Gestion des mofications de recutement ---
		if Json.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
			var node_to_modify = Json.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
			var qty = Json.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
			var node_modified = get_node("Content/Content Holder/Profils/DiplayList/"+node_to_modify)
			if node_modified != null:
				var new_max = qty + node_modified.get_max()
				node_modified.set_max(new_max)
				node_modified.manage_recruitement(node_modified.get_recuitement())
	else:
		show_message("Ajout impossible", "L'ajout de ce profil n'est pas possible.\n La limite de point serait dépassée.")
	
	must_save()
	
func remove_from_team(p, node):
	print("removing " + node.profil["Nom"])
	if (node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste") and hashero:
		hashero = false
		get_node("Save").visible = false
		
	Team.erase(p)
	currentPTS -= int(node.profil["Cout"])
	get_node("Content/Content Holder/ProgressBar").value = currentPTS
	get_node("Content/Content Holder/Panel").avg_stats(Team)
	
#	--- Gestion de l'atteinte du min de recrutement ---
	node.manage_recruitement(node.get_recuitement() - 1)
	
#		--- Gestion des mofications de recutement ---
	if Json.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content/Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = node_modified.get_max() - qty 
			var nb_recuited = node_modified.get_recuitement()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(new_max)
			if nb_recuited > new_max:
				for _i in range(nb_recuited - new_max):
					Team.remove(Team.find(node_modified.profil))
					currentPTS -= int(node_modified.profil["Cout"])
					get_node("Content/Content Holder/ProgressBar").value = currentPTS
					get_node("Content/Content Holder/Panel").avg_stats(Team)
					
	must_save()
	
func show_message(title, msg):
	get_node("OverWriteDialog").window_title = title
	get_node("OverWriteDialog").dialog_text = msg
	get_node("OverWriteDialog").popup_centered()
	
func must_save():
	get_node("Save").visible = Team != Json.get_team(cur_team)[1]
	
func save(id):
	get_node("SaveDialoge").add_cancel("Annuler")
	get_node("SaveDialoge").dialog_text = "Voulez-vous enregistrer les modifications faites à la liste " + teams[id].split(".json")[0] + " ?"
	get_node("SaveDialoge").connect("confirmed", self, "save_changes", [id])
	get_node("SaveDialoge").popup_centered()
	
func save_changes(id):
	var path = "user://" + teams[id]
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.WRITE)
		var team_stored = [get_node("Content/Faction").text, Team]
		file.store_string(to_json(team_stored))
		file.close()
	else:
		show_message("Problème d'enregistrement", "La liste n'existe pas o_O ?")
		
func export_test(list):
	get_node("ExportImport").export_list("Blitz", list)
