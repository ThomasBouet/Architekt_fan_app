extends Control


const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var hashero = false
var maxPts = 180
var currentPTS = 0
var Team = []
var list_hero = []
var list_alchi = []
var list_tpe = []

func _ready():
	get_node("Faction").text = "Profils"
	
	get_node("Content Holder/Panel").init()
	get_node("Content Holder/Panel").visible = false
	get_node("Content Holder/ProgressBar").visible = false
	
	refresh_profils_list(Json_reader.load_all_factions(), true)
	
	get_node("SaveDialog").add_cancel("Annuler")
	get_node("SaveDialog").register_text_enter(get_node("SaveDialog/LineEdit"))
	
func add_to_team(p, node):
#	print("adding " + node.profil["Nom"])
	if node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste":
		if hashero:
#			TODO: Mettre un popup
			show_message("Ajout impossible", "Un héros se trouve déjà dans votre liste.\nVous ne pouvez avoir qu'un seul héro par liste.")
			return
		else:
			hashero = true
			get_node("Save").visible = true
#	--- On autorise l'ajout que s'il l'on peut encore ajouter sans dépasser le seuil ---
	if currentPTS + int(node.profil["Cout"]) <= maxPts:
		Team.append(p)
		currentPTS += int(node.profil["Cout"])
		get_node("Content Holder/ProgressBar").value = currentPTS
		get_node("Content Holder/Panel").avg_stats(Team)
		
#		--- Gestion de l'atteinte du max de recrutement ---
		node.manage_recruitement(node.get_recuitement() + 1)
		
#		--- Gestion des mofications de recutement ---
		if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
			var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
			var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
			var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
			if node_modified != null:
				var new_max = qty + node_modified.get_max()
				node_modified.set_max(new_max)
				node_modified.manage_recruitement(node_modified.get_recuitement())
	else:
#		TODO: Mettre un popup
		show_message("Ajout impossible", "L'ajout de ce profil n'est pas possible.\n La limite de point serait dépassée.")
	
func remove_from_team(p, node):
#	print("removing " + node.profil["Nom"])
	if (node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste") and hashero:
		hashero = false
		get_node("Save").visible = false
		
	Team.remove(Team.find(p))
	currentPTS -= int(node.profil["Cout"])
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/Panel").avg_stats(Team)
	
#	--- Gestion de l'atteinte du min de recrutement ---
	node.manage_recruitement(node.get_recuitement() - 1)
	
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = node_modified.get_max() - qty 
			var nb_recuited = node_modified.get_recuitement()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(new_max)
			if nb_recuited > new_max:
				for _i in range(nb_recuited - new_max):
					Team.remove(Team.find(node_modified.profil))
					currentPTS -= int(node_modified.profil["Cout"])
					get_node("Content Holder/ProgressBar").value = currentPTS
					get_node("Content Holder/Panel").avg_stats(Team)
	
# --- Gestion des boutons du menu --
func move_menu():
	var init_pos = get_node("Factions").position
	var target = Vector2(init_pos.x + (319 if !MenuOpen else -319), init_pos.y)
	get_node("Factions").move(target)
	MenuOpen = !MenuOpen
	
func _on_MenuBtn_pressed():
	move_menu()
	
func _on_Tous_pressed():
	Team = []
	hashero = false
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Panel").visible = false
	get_node("Content Holder/ProgressBar").visible = false
	get_node("Content Holder/HBoxContainer2").visible = false
	refresh_profils_list(Json_reader.load_all_factions(), true)
	move_menu()
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	Team = []
	hashero = false
	get_node("Faction").text = faction
	get_node("Content Holder/Panel").visible = true
	get_node("Content Holder/Panel").resize_self()
	get_node("Content Holder/ProgressBar").visible = true
	get_node("Content Holder/HBoxContainer2").visible = true
	refresh_profils_list(Json_reader.profils_data[faction])
	move_menu()
	
func refresh_profils_list(list, hide=false):
	get_node("Content Holder/HBoxContainer/heros").disconnect("toggled", self, "display_list")
	get_node("Content Holder/HBoxContainer/alchis").disconnect("toggled", self, "display_list")
	get_node("Content Holder/HBoxContainer/troupes").disconnect("toggled", self, "display_list")

	list_hero = []
	list_alchi = []
	list_tpe = []
	var lists = Json_reader.get_list_for_each_type(list)
	var node = get_node("Content Holder/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	var hero_label = Label.new()
	hero_label.text = "Héros"
	hero_label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(hero_label)
#	--- Ajoute tout les héros de la faction correspondante ---	
	for p in lists[0]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_hero.append(profil)
		
	var alchi_label = Label.new()
	alchi_label.text = "Alchimistes"
	alchi_label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(alchi_label)
#	--- Ajoute tout les alchimistes et héros de la faction correspondante ---	
	for p in lists[1]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_alchi.append(profil)
		
	var troupe_label = Label.new()
	troupe_label.text = "Troupes"
	troupe_label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(troupe_label)
#	--- Ajoute toutes les troupes de la faction correspondante ---	
	for p in lists[2]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_tpe.append(profil)
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	node.add_child(c)
	
	get_node("Content Holder/HBoxContainer/heros").connect("toggled", self, "display_list", [list_hero])
	get_node("Content Holder/HBoxContainer/alchis").connect("toggled", self, "display_list", [list_alchi])
	get_node("Content Holder/HBoxContainer/troupes").connect("toggled", self, "display_list", [list_tpe])
	
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	
func _on_ProgressBar_value_changed(value):
	get_node("Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	
func _on_TextureButton_pressed():
	get_node("SaveDialog").popup_centered()
	
func _on_SaveDialog_confirmed():
	var path = "user://" + get_node("SaveDialog/LineEdit").text + ".json"
	var file = File.new()
	if file.file_exists(path):
		show_message("Problème d'enregistrement", "Fichier déjà existant")
	else:
		file.open(path, File.WRITE)
		var team_stored = [maxPts, get_node("Faction").text, Team]
		file.store_string(to_json(team_stored))
		file.close()
		get_node("SaveDialog/LineEdit").text = ""
	
func show_message(title, msg):
	get_node("OverWriteDialog").window_title = title
	get_node("OverWriteDialog").dialog_text = msg
	get_node("OverWriteDialog").popup_centered()
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = list_hero + list_alchi + list_tpe
		
	for n in nodes_profil:
		var name = n.get_node("Nom/Label").text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
func _on_SpinBox_value_changed(value):
	maxPts = int(value)
	_on_ProgressBar_value_changed(get_node("Content Holder/ProgressBar").value)
	pass # Replace with function body.
