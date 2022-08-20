extends Node

onready var food = $FoodPellet.duplicate()

func _ready():
	for i in 500:
		var f = food.duplicate()
		f.position.x = rand_range(-1000, 1000)
		f.position.y = rand_range(-1000, 1000)
		add_child(f)

func _process(delta):
	if randf() < 0.03:
		var f = food.duplicate()
		f.position.x = rand_range(-1000, 1000)
		f.position.y = rand_range(-1000, 1000)
		add_child(f)
		
