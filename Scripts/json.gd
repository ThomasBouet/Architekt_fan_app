extends Node


var profils_data = []
var comps_data = []
var forms_data = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var json_file = File.new()
	json_file.open("res://profils.json", File.READ)
	profils_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	json_file = File.new()
	json_file.open("res://competences.json", File.READ)
	comps_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	json_file = File.new()
	json_file.open("res://formules.json", File.READ)
	forms_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
func load_all_factions():
	var all_list = []
	var all_name = []
	for l in profils_data.values():
		for i in l:
#			print(i["Nom"])
			if !all_name.has(i["ID"]):
				all_list.append(i)
				all_name.append(i["ID"])
				
#	print(all_name)
	return all_list
	
func get_list_for_each_type(list):
	var heros = []
	var alchis = []
	var troupes = []
	
	for i in list:
		match i["Type"]:
			"Troupe":
				troupes.append(i)
			"Spécial":
				troupes.append(i)
			"Alchimiste":
				alchis.append(i)
			"Héro":
				heros.append(i)
			"Héro/Alchimiste":
				heros.append(i)
	return [heros, alchis, troupes]
	
func has_team_saved():
	var nb = 0
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".json"):
			nb += 1
	dir.list_dir_end()
	return nb > 0
	
func get_team_saved():
	var teams = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".json"):
			teams.append(file)
	dir.list_dir_end()
	return teams
	
func get_team(nom):
	var json_file = File.new()
	json_file.open("user://" + nom, File.READ)
	var team_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	return team_data
	
const CHANGE_RECRUTEMENT = {
#	"nom de la fig qui change les règles": ["fig changée": bonus de recrutement]
	"Lotharius": ["Templier", 1],
	"Rigosane": ["Martyr", 2],
	"Dhalia": ["Ghulam", 2],
	"Deicolius": ["Novice-Temple", 3],
	"Pitekica": ["Chaman-Medecine", 1],
	"Evocatrice-Sornha": ["Djinn", 1]
}
