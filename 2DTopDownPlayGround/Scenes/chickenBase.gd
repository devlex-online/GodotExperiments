extends Node2D

class_name ChickenBase

export(int) var gender

onready var needs_controller = get_node("NeedsController")
onready var reproduction_controller = get_node("ReproductionController")


func _ready():
	reproduction_controller.gender = gender;
	reproduction_controller.connect("birth", self, "reproduction_controller_on_birth")
	reproduction_controller.connect("had_sex", self, "reproduction_controller_on_had_sex")
	needs_controller.connect("sex_with", self, "reproduction_controller_on_sex_with")

func reproduction_controller_on_birth(baby : Node):
	baby.position = get_parent().position
	get_parent().get_parent().add_child(baby)

func reproduction_controller_on_sex_with(other : Node):
	var other_reproduction_controller = other.get_node_or_null("ReproductionController")
	reproduction_controller.sex(other_reproduction_controller)

func reproduction_controller_on_had_sex():
	if gender == 1:
		needs_controller.modify_reproduction(needs_controller.reproduction_max / 2 * -1)
	else:
		needs_controller.modify_reproduction(needs_controller.reproduction_max * -1)

