extends Node3D

@export var nametext ="ticked off vic"
@export var text = "HOW THE FUCK DOES THAT HELP YOU GREEDY COCK SUCKERS"
signal textvals
# https://www.youtube.com/clip/UgkxxFHVDye9vhsNZzkjKK-8LNNGb5yWXmPY ticked off vic!
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $StaticBody3D/Area3D.get_overlapping_areas():
		emit_signal("textvals", nametext, text)
