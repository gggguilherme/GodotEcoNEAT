extends Node
# To utilize this asset, extend both NN_Agent and NN_Population and define your static functions, listed below.

class_name OrganismAgent # Give it whatever name you want, but don't forget to give it one.
# hmm don't confuse with orgasm

# get the body of the organism to evolve
var body_scene := "res://Examples/Organism.tscn"
var body

# reference to the population node
var pop_ref

# genome
var brain 

# way to reference the outputs and inputs
var decision := []
var vision := []

var genome_inputs := []
var genome_outputs := []
var id := 0

var active := true

var energy := 50.0
var health := 50.0

func generate(body_path : String, pop):
	body = load(body_path).instance()
	body.position = Vector2(rand_range(-500, 500), rand_range(-500, 500))
	add_child(body)
	genome_inputs = body.get_inputs(true)
	genome_outputs = body.get_outputs(true)
	
	pop_ref = pop
	
	brain = NN_Genome.new(genome_inputs.size(), genome_outputs.size(), false, self, pop_ref.innovation_history)
	add_child(brain)
	decision.resize(genome_outputs.size())
	for i in decision:
		i = 0.0
	vision.resize(genome_inputs.size())
	return self

# A constructor to be used internally. Use this to clone an empty agent, if needed.
func generate_internal(body_path : String, clone : bool, pop):
	body = load(body_path).instance()
	body.position = Vector2(rand_range(-100, 100), rand_range(-100, 100))
	add_child(body)
	genome_inputs = body.get_inputs(true)
	genome_outputs = body.get_outputs(true)
	
	pop_ref = pop
	
	if (!clone):
		brain = NN_Genome.new(genome_inputs.size(), genome_outputs.size(), false, self, pop_ref.innovation_history)
		add_child(brain)
	decision.resize(genome_outputs.size())
	for i in decision:
		i = 0.0
	vision.resize(genome_inputs.size())
	return self

# What does a Neural Network do?
# Think, anon, think!
func think():
	update()
	if (active):
		look()
		decision = brain.feed_forward(vision)
		move()
	else:
		dead()
	finally()

# While thinking, the Neural Network will go through some phases.
func update(): # First, it will call update() regardless of active status.
	pass # You can put whatever needs to be done before adding the inputs here.

func look(): # Then, if active, it calls look().
	vision = [
		1.0,
		1 / energy,
		1 / health,
	]
	vision.append_array(body.get_structure_inputs())

# Then, it resolves the Network with current inputs.
func move(): # Then, it calls move().
	
	var foward_velocity = decision[0] * 10 # move
	var turning_right = decision[1] # turn
	var turning_left = decision[2] # turn
	var reproduce = decision[3] # reproduce
	var mouth = decision[4] # mouth
	
	if foward_velocity > 0.0:
		body.position += Vector2(cos(body.rotation), sin(body.rotation)) * foward_velocity
		body.rotation_degrees += turning_right - turning_left
		energy -= 0.01 * foward_velocity * (sign(turning_left) * turning_right) / 2
	
	
	if mouth && body.check_mouth_area():
		digest()
	
	if bool(reproduce) && energy > 90.0:
		asex_clone()
		
	if energy < 0.0:
		active = false
	
	energy -= 0.02

func dead(): # If (active == false), then this will be executed.
	pass # If you want it to do something if inactive, write it here.

func finally(): # This is called at the end of the think() function.
	pass # Here just in case.

# As the duplicate() function sucks in Godot, this is really necessary.
func clone():
	var clone = get_script().new().generate_internal(body_scene, true, pop_ref)
	clone.energy = 50.0
	clone.brain = brain.clone()
	clone.add_child(clone.brain)
	clone.brain.generate_network()
	return clone


func digest():
	for i in body.get_mouths():
		for j in i.get_node("Area").get_overlapping_areas():
			if "Food" in j.name:
				j.queue_free()
				energy += j.energy


func mutate():
	pass


# rt-NEAT:
# asexual reproduction
# who needs bitches?
func asex_clone():
	var clone = clone()
	pop_ref.add_to_population(clone)
	clone.brain.mutate(pop_ref.innovation_history)
	clone.body.position = body.position
	energy -= 90.0
