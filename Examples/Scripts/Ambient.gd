extends Node
# To utilize this asset, extend both NN_Agent and NN_Population and define your static functions, listed below.
class_name Ambient # Give it whatever name you want, but don't forget to give it one.

var rng := RandomNumberGenerator.new()

var pop := []
var innovation_history := []
var next_connection_number := 0

# Whenever you want to generate the network, call generate(n), where n is the number of agents you wish to create.
func _ready():
	generate(30)

# A constructor would make this very hard to extend, so call it like My_Population.new().generate(a, b, c, d)
func generate(size : int):
	rng.randomize()
	for i in range(size):
		pop.append(create_agent())
		pop[i].id = i
		pop[i].brain.generate_network()
		pop[i].brain.mutate(innovation_history)
		add_child(pop[i])
	return self

# Don't forget to write this function, so the parent class can call your Agent class, instead of the base one.
func create_agent():
	return OrganismAgent.new().generate("res://Examples/Organism.tscn", self)
	# This function must have this format:
	# return Agent_Name.new().generate(inputs, outputs, self)

func add_to_population(agent):
	pop.append(agent)
	pop.back().id = pop.size() - 1
	pop.back().brain.generate_network()
	add_child(pop.back())

func _physics_process(_delta):
	for b in pop:
		if b.active:
			b.think()
			continue
		else:
			pop.erase(b)
			b.body.free()
			continue

func _input(event):
	if Input.is_action_just_pressed("ui_home"):
		get_tree().reload_current_scene()
