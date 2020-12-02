extends Node


var heros_limit = 1
#	1,2 ou Loge.
	
func add_to_team(maxPts, curPts, faction, Team, node):
	#	print("adding " + node.profil["Nom"])
	var can_add_heros = false
	var can_add_profil = true
	var p = node.profil
	check_heros_limit(maxPts, faction)
	var nb_heros = get_nb_heros(Team)
	match heros_limit:
		1:
			if nb_heros <= heros_limit:
				 can_add_heros = true
		2:
			if nb_heros <= heros_limit:
				 can_add_heros = true
		"Loges":
			can_add_heros = true
	
	if int(p["Cout"]) + curPts > maxPts:
		can_add_profil = false
		
	var old_Team_size = Team.size()
		
	if ((p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste") and can_add_profil) and can_add_heros:
		Team.append(p)
	elif can_add_profil and (p["Type"] != "Héro" and p["Type"] != "Héro/Alchimiste"):
		Team.append(p)

	if Team.size() != old_Team_size:
		curPts += int(p["Cout"])
#		--- Gestion de l'atteinte du max de recrutement ---
		node.manage_recruitement(node.get_recuitement() + 1)
		return [Team, curPts]
	else:
		return "La limite de héros à déjà été atteinte" if !can_add_heros and can_add_profil else "La limite de point est dépassé avec l'ajout de ce profil"
	
func remove_from_team(curPts, Team, node):
	var p = node.profil
	Team.erase(p)
	curPts -= int(p["Cout"])
	
#	--- Gestion de l'atteinte du min de recrutement ---
	node.manage_recruitement(node.get_recuitement() - 1)

	return [Team, curPts]
	
func check_heros_limit(max_pts, faction):
	if max_pts <= 200:
		heros_limit = 1
	else:
		heros_limit = 2
	if faction == "Loges":
		heros_limit = "Loges"
	
func get_nb_heros(list):
	var nb = 0
	for i in list:
		if i["Type"] == "Héro" or i["Type"] == "Héro/Alchimiste":
			nb += 1
	return nb
	
func sort_profil_list(list):
	list.sort_custom(CustomSort, "custom_sort_profil")
	return list
	
func compare_list(list1, list2):
	if list1.size() != list2.size():
		return false
	var ids1 = []
	var ids2 = []
	for i in list1.size():
		ids1.append(list1[i]["ID"])
		ids2.append(list2[i]["ID"])
	ids1.sort()
	ids2.sort()
	
	return ids1 == ids2
	
func unlock_sarge(team, sarge):
	var id_gt = 40
	var nb_gt = 0
	for p in team:
		if p["ID"] == id_gt:
			nb_gt += 1
	
	if sarge != null and nb_gt == 3 :
		if sarge.get_max() < 1:
			sarge.set_max(sarge.get_max() + 1)
			sarge.manage_recruitement(sarge.get_recuitement())
		
func lock_sarge(team, sarge, curPts):
	var id_gt = 40
	var id_sgt = 41
	var has_sgt = false
	var nb_gt = 0
	for p in team:
		if p["ID"] == id_gt:
			nb_gt += 1
		if p["ID"] == id_sgt:
			has_sgt = true
	
	if sarge != null and nb_gt < 3 and has_sgt:
		curPts -= int(sarge.profil["Cout"])
		team.erase(sarge.profil)
		sarge.set_max(sarge.get_max() - 1)
		sarge.manage_recruitement(sarge.get_recuitement() - 1)
		
	return [team, curPts]
	
func unlock_animals(team, profils_list):
	var has_dresseur = false
	for p in team:
		if "Dresseur" in p["Compétences"].split(','):
			has_dresseur = true
			break
			
	if !has_dresseur:
			return
			
	var animals_nodes = []
	for p in profils_list:
		if "Animal sauvage" in p.profil["Compétences"].split(',') :
			animals_nodes.append(p)
			
	if animals_nodes != []:
		for n in animals_nodes:
			if n.get_max() < 3:
				n.set_max(n.get_max() + 3)
				n.manage_recruitement(n.get_recuitement())

func lock_animals(team, profils_list, curPts):
	var has_dresseur = false
	for p in team:
		if "Dresseur" in p["Compétences"].split(','):
			has_dresseur = true
			break
			
	if has_dresseur:
		return [team, curPts]
		
	var animals_nodes = []
	for p in profils_list:
		if "Animal sauvage" in p.profil["Compétences"] :
			animals_nodes.append(p)
		
	for n in animals_nodes:
		var nb_recruited = n.get_recuitement()
		var new_max = n.get_max() - 3
		if nb_recruited > new_max and nb_recruited != 0:
				for _i in range(nb_recruited - new_max):
					team.erase(n.profil)
					curPts -= int(n.profil["Cout"])
		n.set_max(new_max)
		n.manage_recruitement(0)
	
	return [team, curPts]
	
class CustomSort:
	static func custom_sort_profil(elmnt1, elmnt2):
		var res = elmnt1["Nom"].casecmp_to(elmnt2["Nom"])
		match res:
			-1 :
				return true
			1 : 
				return false
			0 : 
				return false
	
