extends Node2D
class_name Organism

var structure := []
var input_structures := []
var output_structures := []

enum structures {Eye, Membrane, Appendage, Mouth, Organel, Nucleus ,MAX}

func get_mouths():
	var arr = []
	for i in structure:
		if "Mouth" in i.name:
			arr.append(i)
	return arr

func check_mouth_area():
	for i in get_mouths():
		if i.get_node('Area').get_overlapping_areas().size() > 0:
			return true
	return false

func get_structure(update = false):
	if update:
		structure = []
		for i in get_children():
			structure.append(i)
	return structure

func get_inputs(update = false):
	if update:
		input_structures = []
		for i in get_structure(update):
			for check in ['Eye', 'Membrane', "Mouth"]:
				if check in i.name:
					input_structures.append(i)
	return input_structures

func get_outputs(update = false):
	if update:
		output_structures = []
		for i in structure:
			for check in ['Appendage', 'Mouth', "Organel", "Nucleus"]:
				if check in i.name:
					output_structures.append(i)
	return output_structures


func get_structure_inputs():
	var inp = get_inputs()
	var res = []
	for i in inp:
		if "Eye" in i.name:
			res.append(i.get_node("Area").get_overlapping_areas().size() / 10.0)
		if "Mouth" in i.name:
			res.append(i.get_node("Area").get_overlapping_areas().size() / 10.0)
	return res


func mutate_structure():
	randomize()
	if randf() < 0.02:
		add_structure(rand_range(0, get_child_count()-1) as int)
	elif randf() < 0.02:
		remove_structure(rand_range(0, structure.size()) as int)

func add_structure(i : int):
	var n = get_child(i).duplicate()
	n.position = Vector2(rand_range(-32, 32), rand_range(-32, 32))
	add_child(n, true)
	structure = get_structure(true)
	output_structures = get_outputs(true)
	input_structures = get_inputs(true)

func remove_structure(i : int):
	structure.remove(i)
