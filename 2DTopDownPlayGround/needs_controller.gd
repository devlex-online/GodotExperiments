extends Node

class_name needs_controller

export var hunger_rate : float = 1.0
export var thirst_rate : float = 1.0
export var reproduction_rate : float = 1.0

export var hunger_max : float = 100.0
export var thirst_max : float = 100.0
export var reproduction_max : float = 100.0

export var always_eat_limit : float = 50.0
export var maybe_eat_limit : float = 25.0
export var always_drink_limit : float = 50.0
export var maybe_drink_limit : float = 25.0

export var eat_area_path : NodePath
export var search_food_area_path : NodePath
export var random_movement_controller_path : NodePath

onready var random_movement_controller = get_node(random_movement_controller_path)

var hunger : float
var thirst : float
var reproduction : float

var rng : RandomNumberGenerator

var has_target_food : bool

signal sex_with(other)

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var area2D : Area2D= get_node(eat_area_path)
	area2D.connect("area_entered", self, "on_eat_area_area_entered")
	
	area2D = get_node(search_food_area_path)
	area2D.connect("area_entered", self, "on_search_food_area_area_entered")
	
func set_target_food(target: Vector2):
	has_target_food = true
	random_movement_controller.set_target(target)

func clear_target_food():
	has_target_food = false
	random_movement_controller.set_target(null)

func on_search_food_area_area_entered(area : Area2D):
	if area.is_in_group("PlantArea") && hunger > always_eat_limit && !has_target_food:
		var node = area.get_node_or_null(NodePath("EatableObject"))
		if node != null:
			set_target_food(node.get_parent().position)
	elif area.is_in_group("WaterArea") && thirst > always_drink_limit && !has_target_food:
		set_target_food(area.position)
	elif area.is_in_group("ReproductionArea") && abs(reproduction - reproduction_max) < 0.5 && !has_target_food:
			set_target_food(area.get_parent().get_parent().position)

func on_eat_area_area_entered(area : Area2D):
	if area.is_in_group("PlantArea"):
		if hunger > always_eat_limit:
			var node = area.get_node_or_null(NodePath("EatableObject"))
			if node != null:
				eat(node)
		elif hunger > maybe_eat_limit && rng.randi_range(1,100) > 90:
			var node = area.get_node_or_null(NodePath("EatableObject"))
			if node != null:
				eat(node)
	elif area.is_in_group("WaterArea"):
		if thirst > always_drink_limit:
			drink()
		elif thirst > maybe_drink_limit && rng.randi_range(1,100) > 90:
			drink()
	elif area.is_in_group("ReproductionArea"):
		if abs(reproduction - reproduction_max) < 0.5:
			emit_signal("sex_with", area.get_parent())

func drink():
	modify_thirst(thirst_max * -1)
	clear_target_food()

func eat(eatableObject):
	hunger = modify_need(hunger, eatableObject.hunger_modifier, hunger_max)
	var tile_map : TileMap = eatableObject.get_parent().get_parent()
	var tile_pos = tile_map.world_to_map(eatableObject.get_parent().position)
	tile_map.set_cellv(tile_pos, -1)
	eatableObject.get_parent().queue_free()
	clear_target_food()

func modify_thirst(modifier : float):
	thirst = modify_need(thirst, modifier, thirst_max)

func modify_reproduction(modifier : float):
	reproduction = modify_need(reproduction, modifier, reproduction_max)

func modify_need(value : float, modifier : float, max_value : float) -> float:
	value += modifier
	if value >= max_value:
		return max_value
	if value <= 0.0: 
		return 0.0
	return value

func _process(delta):
	hunger = rate_calculation(hunger, hunger_rate, hunger_max, delta)
	thirst = rate_calculation(thirst, thirst_rate, thirst_max, delta)
	reproduction = rate_calculation(reproduction, reproduction_rate, reproduction_max, delta)
	
	if hunger <= always_eat_limit:
		clear_target_food()

func rate_calculation(value : float, rate_per_second : float, max_value : float, delta : float) -> float:
	value += rate_per_second * delta
	if value >= max_value:
		return max_value
	return value
