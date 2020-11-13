extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Scenar = preload("res://Scenes/scenar.tscn")
var MenuOpen = false
var scenarios = []
	
func _ready():
	var json_file = File.new()
	json_file.open("res://scenar.json", File.READ)
	scenarios = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	refresh_scenarios_list(scenarios)
	
func refresh_scenarios_list(list):
	var node = get_node("Content Holder/Scenars/DisplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for s in list:
		var scenar = Scenar.instance().init(s)
		scenar.name = s["Nom"]
		get_node("Content Holder/Scenars/DisplayList").add_child(scenar)
		scenar.resize_self()
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	get_node("Content Holder/Scenars/DisplayList").add_child(c)
	
# --- Gestion des boutons du menu --
func move_menu():
	var init_pos = get_node("Menu").position
	var target = Vector2(init_pos.x + (319 if !MenuOpen else -319), init_pos.y)
	get_node("Menu").move(target)
	MenuOpen = !MenuOpen
	
func _on_MenuBtn_pressed():
	move_menu()	
	
func _on_Accueil_pressed():
	get_tree().change_scene("res://Scenes/Accueil.tscn")
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = get_node("Content Holder/Scenars/DisplayList").get_children()
	nodes_profil.pop_back()
	
	for n in nodes_profil:
		var name = n.get_child(1).get_child(0).text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
