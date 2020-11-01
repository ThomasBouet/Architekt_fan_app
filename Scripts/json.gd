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
	
	
	print([1,2,3,1].find(4))
	
func load_all_factions():
	var all_list = []
	for l in Json.profils_data.values():
		for i in l:
			if !all_list.has(i):
				all_list.append(i)
				
	return all_list
	
const CHANGE_RECRUTEMENT = {
#	"nom de la fig qui change les règles": ["fig changée": bonus de recrutement]
	"Lotharius": ["Templier", 1],
	"Rigosane": ["Martyr", 2],
	"Dhalia": ["Ghulam", 2],
	"Deicolius": ["Novice-temple", 3],
	"Pitekica": ["Chaman-medecine", 1]
}
