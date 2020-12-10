extends Control


var MenuOpen = true
const load_timer = 0.2

func _ready():
	get_node("Content Holder/Profils_list_display").connect("save", self, "show_savebutton")
	_on_Tous_pressed()
	
	get_node("Faction").text = "Profils"
	get_node("SaveDialog").register_text_enter(get_node("SaveDialog/LineEdit"))
	
func move_menu():
	MenuOpen = !MenuOpen
	get_node("Factions/ColorRect").visible = MenuOpen
	get_node("Factions/HBoxContainer/VBoxContainer").visible = MenuOpen
	
func _on_MenuButton_pressed():
	move_menu()
	
func _on_Tous_pressed():
	move_menu()
	get_node("icon").loading()
	yield(get_tree().create_timer(load_timer), "timeout")
	get_node("Content Holder/SaveButton").visible = false
	get_node("Faction").text = "Profils"
	get_node("Content Holder/Profils_list_display").call_deferred("change_tous")
	yield(get_tree().create_timer(load_timer), "timeout")
	get_node("icon").hide_loading()
	
# --- Gestion de l'affichage des profils ---
func _change_faction(faction):
	move_menu()
	get_node("icon").loading()
	yield(get_tree().create_timer(load_timer), "timeout")
	get_node("Faction").text = faction
	get_node("Content Holder/Profils_list_display").call_deferred("change_faction", faction)
	yield(get_tree().create_timer(load_timer), "timeout")
	get_node("icon").hide_loading()
	
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
	
	
