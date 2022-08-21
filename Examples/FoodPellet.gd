extends Area2D


var energy = 10.0
func _ready():
	energy += rand_range(-10.0, 40.0)
