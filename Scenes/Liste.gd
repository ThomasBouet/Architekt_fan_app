extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var maxPts = 180
var teams = Json.get_team_saved()

func _ready():
	get_node("MesListes").text = "Mes Listes"
	
	get_node("Content/Content Holder/Panel").init()
	get_node("Content/Content Holder/Panel").visible = false
	get_node("Content/Content Holder/ProgressBar").visible = false
	
#	refresh_profils_list(Json.load_all_factions(), true)
	for t in teams:
		print(t.split(".json"))
		var nom = t.split(".json")[0]
		var button = Button.new()
		button.name = nom
		button.text = nom
		var font = DynamicFont.new()
		font = ResourceLoader.load("res://Spartan_Bold.tres")
		button.add_font_override("font", font)
		get_node("Content/Listes").add_child(button)
	
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
	
	for i in range(len(files)):
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
	
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	get_node("Faction").text = faction
	get_node("Content/Content Holder/Panel").visible = true
	get_node("Content/Content Holder/ProgressBar").visible = true
	refresh_profils_list(Json.profils_data[faction])
	move_menu()
	
func refresh_profils_list(list, hide=true):
	var node = get_node("Content/Content Holder/Profils/DiplayList")
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
		
		if p["Type"] == "Troupe":
			profil.get_child(10).texture = ResourceLoader.load("res://Sprites/UI/sword_01c.png")
		elif p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			profil.get_child(10).texture = ResourceLoader.load("res://Sprites/UI/helmet_02d.png")
		elif p["Type"] == "Alchimiste":
			profil.get_child(10).texture = ResourceLoader.load("res://Sprites/UI/potion_03c.png")
		elif p["Type"] == "Special" or p["Type"] == "Spécial":
			profil.get_child(10).texture = ResourceLoader.load("res://Sprites/UI/cookie_01a.png")
			
		profil.get_child(4).text = "0" 
		if p["Max"] == "0" or hide:
			profil.get_child(8).visible = false
		get_node("Content/Content Holder/Profils/DiplayList").add_child(profil)
	
func _on_ProgressBar_value_changed(value):
	get_node("Content/Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	
func show_message(title, msg):
	get_node("OverWriteDialog").window_title = title
	get_node("OverWriteDialog").dialog_text = msg
	get_node("OverWriteDialog").popup_centered()
	
func _on_Accueil_pressed():
	get_tree().change_scene("res://Scenes/Accueil.tscn")
