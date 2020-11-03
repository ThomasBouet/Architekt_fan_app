extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var profils_data
# Called when the node enters the scene tree for the first time.
func _ready():
	var json_file = File.new()
	json_file.open("res://profils.json", File.READ)
	profils_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
func load_all_factions():
	var all_list = []
	for l in Json.profils_data.values():
		for i in l:
			if !all_list.has(i):
				all_list.append(i)
				
	return all_list
	
func has_team_saved():
	var nb = 0
	var dir = Directory.new()
	dir.open("res://Data")
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
	dir.open("res://Data")
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
	json_file.open("res://Data/" + nom, File.READ)
	var team_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	return team_data
	
const CHANGE_RECRUTEMENT = {
#	"nom de la fig qui change les règles": ["fig changée": bonus de recrutement]
	"Lotharius": ["Templier", 1],
	"Rigosane": ["Martyr", 2],
	"Dhalia": ["Ghulam", 2],
	"Deicolius": ["Novice-temple", 3],
	"Pitekica": ["Chaman-medecine", 1]
}
