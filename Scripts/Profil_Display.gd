extends Control


var MenuOpen = true

func _ready():
	get_node("Content Holder/Profils_list_display").connect("begin_loading", get_node("Loading_animation"), "loading")
	get_node("Content Holder/Profils_list_display").connect("end_loading", get_node("Loading_animation"), "hide_loading")
	get_node("Content Holder/Profils_list_display").connect("save", self, "show_savebutton")
	get_node("Loading_animation").loading()
	_on_Tous_pressed()
	
	get_node("Faction").text = "Profils"
	
	get_node("SaveDialog").register_text_enter(get_node("SaveDialog/LineEdit"))
	get_node("Loading_animation").hide_loading()
	
func move_menu():
	MenuOpen = !MenuOpen
	get_node("Factions/ColorRect").visible = MenuOpen
	get_node("Factions/HBoxContainer/VBoxContainer").visible = MenuOpen
	
func _on_MenuButton_pressed():
	move_menu()
	
func _on_Tous_pressed():
	move_menu()
	get_node("Loading_animation").loading()
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Profils_list_display").change_tous()
	get_node("Loading_animation").hide_loading()
	
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	get_node("Loading_animation").loading()
	move_menu()
	get_node("Faction").text = faction
	get_node("Content Holder/Profils_list_display").change_faction(faction)
	get_node("Loading_animation").hide_loading()
	
func _on_SaveButton_pressed():
	get_node("SaveDialog").popup_centered()
	
func _on_SaveDialog_confirmed():
	var path = "user://" + get_node("SaveDialog/LineEdit").text + ".json"
	var file = File.new()
	if file.file_exists(path):
		show_message("Problème d'enregistrement", "Fichier déjà existant")
	else:
		file.open(path, File.WRITE)
		var Team = get_node("Content Holder/Profils_list_display").get_Team()
		var maxPts = get_node("Content Holder/Profils_list_display").get_maxPts()
		var team_stored = [maxPts, get_node("Faction").text, Team]
		file.store_string(to_json(team_stored))
		file.close()
		get_node("SaveDialog/LineEdit").text = ""
		show_message("Sauvegarde", "La sauvegarde a été un succès" if file.file_exists(path) else "La sauvegarde a échoué suite à un problème inconnu.")
	
func show_message(title, msg):
	get_node("DisplayDialog").show_dialog(title, msg)
	
func show_savebutton(state):
	get_node("Content Holder/SaveButton").visible = state
	

