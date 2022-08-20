extends Area2D


var energy = 10.0
func _ready():
	energy += rand_range(-5.0, 20.0)
