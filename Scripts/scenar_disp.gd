extends Control


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
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = get_node("Content Holder/Scenars/DisplayList").get_children()
	nodes_profil.pop_back()
	
	for n in nodes_profil:
		var name = n.get_child(1).get_child(0).text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
func _on_Button_pressed():
	if get_tree().change_scene("res://Scenes/regles.tscn") != OK:
		print("Une erreur innatendue est arrivée")
