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
	
	refresh_profils_list(Json_reader.load_all_factions(), true, true)
	
	get_node("SaveDialog").add_cancel("Annuler")
	get_node("SaveDialog").register_text_enter(get_node("SaveDialog/LineEdit"))
	
func add_to_team(node):
#	print("adding " + node.profil["Nom"])
	var res = Team_handler.add_to_team(maxPts, currentPTS, get_node("Faction").text, Team, node)
	if typeof(res) == TYPE_STRING:
		show_message("Ajout impossible", res)
		return
		
	Team = res[0]
	currentPTS = res[1]
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/Panel").avg_stats(Team)
	get_node("Content Holder/SaveButton").visible = Team_handler.get_nb_heros(Team) != 0
	
	if get_node("Faction").text == "Triade de Jade":
		Team_handler.unlock_sarge(Team, get_node("Content Holder/Profils/DiplayList/Sergent"))
	
	if get_node("Faction").text == "Cartel" or get_node("Faction").text == "Khaliman":
		Team_handler.unlock_animals(Team, list_hero + list_alchi + list_tpe)
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = qty + node_modified.get_max()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(node_modified.get_recuitement())
	
func remove_from_team(node):
#	print("removing " + node.profil["Nom"])
	var res = Team_handler.remove_from_team(currentPTS, Team, node)
	Team = res[0]
	currentPTS = res[1]
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/Panel").avg_stats(Team)
	get_node("Content Holder/SaveButton").visible = (Team_handler.get_nb_heros(Team) != 0) if currentPTS < maxPts else false
	
	if get_node("Faction").text == "Triade de Jade":
		var res2 = Team_handler.lock_sarge(Team, get_node("Content Holder/Profils/DiplayList/Sergent"), currentPTS)
		Team = res2[0] 
		currentPTS = res2[1]
		get_node("Content Holder/ProgressBar").value = currentPTS
		get_node("Content Holder/Panel").avg_stats(Team)
		
	if get_node("Faction").text == "Cartel" or get_node("Faction").text == "Khaliman":
		var res2 = Team_handler.lock_animals(Team, list_hero + list_alchi + list_tpe, currentPTS) 
		Team = res2[0]
		currentPTS = res2[1]
		get_node("Content Holder/ProgressBar").value = currentPTS
		get_node("Content Holder/Panel").avg_stats(Team)
	
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
#			print(node_modified.get_max())
			var new_max = node_modified.get_max() - qty 
			var nb_recruited = node_modified.get_recuitement()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(nb_recruited)
			if nb_recruited > new_max:
				for _i in range(nb_recruited - new_max):
					Team.remove(Team.find(node_modified.profil))
					currentPTS -= int(node_modified.profil["Cout"])
					get_node("Content Holder/ProgressBar").value = currentPTS
					get_node("Content Holder/Panel").avg_stats(Team)
	
func move_menu():
	MenuOpen = !MenuOpen
	get_node("Factions/ColorRect").visible = MenuOpen
	get_node("Factions/HBoxContainer/VBoxContainer").visible = MenuOpen
	
func _on_MenuButton_pressed():
	move_menu()
	
func _on_Tous_pressed():
	Team = []
	hashero = false
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Panel").visible = false
	get_node("Content Holder/ProgressBar").visible = false
	get_node("Content Holder/HBoxContainer2").visible = false
	refresh_profils_list(Json_reader.load_all_factions(), true, true)
	move_menu()
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	Team = []
	currentPTS = 0
	hashero = false
	get_node("Faction").text = faction
	get_node("Content Holder/Panel").visible = true
	get_node("Content Holder/Panel").resize_self()
	get_node("Content Holder/ProgressBar").visible = true
	get_node("Content Holder/ProgressBar").value = currentPTS
	get_node("Content Holder/HBoxContainer2").visible = true
	refresh_profils_list(Json_reader.profils_data[faction])
	move_menu()
	
func display_list_type_profil(categorie, list, cat_list, hide):
	var node = get_node("Content Holder/Profils/DiplayList")
	var label = Label.new()
	label.text = categorie
	label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(label)
#	--- Ajoute tout les héros de la faction correspondante ---	
	for p in list:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		cat_list.append(profil)
	
func refresh_profils_list(list, hide=false, tous=false):
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
		
	display_list_type_profil("Héros", lists[0] if !tous else Team_handler.sort_profil_list(lists[0]), list_hero, hide)
	display_list_type_profil("Alchimistes", lists[1] if !tous else Team_handler.sort_profil_list(lists[1]), list_alchi, hide)
	display_list_type_profil("Troupes", lists[2] if !tous else Team_handler.sort_profil_list(lists[2]), list_tpe, hide)
#	
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
	
func _on_SaveButton_pressed():
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
	
