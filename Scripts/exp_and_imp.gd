extends Node


func _ready():
	pass # Replace with function body.
	

const faction_incode = {"Aurlok": 0,"Avalon": 1,"Cartel":2 ,"Evades": 3,"Garde Cobra": 4,"Khaliman": 5,"Loges": 6,"Naashti": 7, "Rados": 8,"Sanctifiés": 9,"Sororité": 10,"Temple": 11,"Triade de Jade": 12,"Utopie": 13,"Waga": 14,"Walosi": 15}
const faction_decode = {0: "Aurlok",1: "Avalon",2: "Cartel",3: "Evades",4: "Garde Cobra",5: "Khaliman",6: "Loges",7: "Naashti", 8: "Rados",9: "Sanctifiés",10: "Sororité",11: "Temple",12: "Triade de Jade",13: "Utopie",14: "Waga",15: "Walosi"}
const Shift = 64
#[
#	maxpts centaine
#	maxpts dizaine
#	maxpts unité
#	faction voir dictionnaire
#	nb de profils
#	id_fig (centaine)
#	id_fig (dizaine)
#	id_fig (entier)
#	etc
#]
#shift de 33

func export_list(list):
	var stored_info = []
		
	stored_info.append(list[0]/100 % 10)
#		print(list[0] / 10 % 10) # Dizaine
	stored_info.append(list[0] / 10 % 10)
#		print(list[0] % 10) # Unité
	stored_info.append(list[0] % 10)
	
	stored_info.append(faction_incode[list[1]])
	stored_info.append(list[2].size())
	
	for p in list[2]:
		var id = int(p["ID"])
#		print(id)
#		print(id/100 % 10) # Centaine
		stored_info.append(id/100 % 10)
#		print(id / 10 % 10) # Dizaine
		stored_info.append(id / 10 % 10)
#		print(id % 10) # Unité
		stored_info.append(id % 10)
		
#	print(stored_info)
	for i in stored_info.size():
		stored_info[i] = stored_info[i] + Shift
#	print(stored_info)
	var list_str = ""
	for i in stored_info:
		list_str = list_str + char(i)
	list_str += "="
#	print(list_str)

	return list_str
	
func import_list(str_list):
	if not str_list.ends_with("=") or len(str_list) <= 6:
		return "La liste ne rentrée ne correspond pas au bon format de liste."
		
	var maxPts = (str_list[0].to_ascii()[0] - Shift) * 100 + (str_list[1].to_ascii()[0] - Shift) * 10 + str_list[2].to_ascii()[0] - Shift
		
	var faction = faction_decode[str_list[1].to_ascii()[0] - Shift]
	var nb_fig = str_list[2].to_ascii()[0] - Shift
	
	var ids = []
	var i = 3
	for _j in range(nb_fig):
		ids.append((str_list[i].to_ascii()[0] - Shift)*100 + (str_list[i+1].to_ascii()[0] - Shift)*10 + (str_list[i+2].to_ascii()[0] - Shift))
		i += 3
		
	var profils = Json_reader.profils_data[faction]
	var team = []
	for id in ids:
		for p in profils:
			if p["ID"] == id:
				team.append(p)
	
#	print(team)
	return [maxPts, faction, team]
