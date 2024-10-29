class_name CooldownResource
extends Resource

@export var cooldown_type : Enums.CooldownType

@export var time_between_shots : float = 1.0

@export_subgroup("Magazine")
@export var time_to_reload : float = 3.0
@export var magazine_size : int = 5

@export_subgroup("Overheat")
@export var overheat_buildup : float = 5.0
@export var overheat_threshold : float = 100.0
@export var overheat_dropoff_per_second : float = 10.0
@export var overheat_dropoff_delay : float = 2.0
@export var overheat_modifier : ModifierData

var cooldown_type_map : Dictionary = {
	Enums.CooldownType.SIMPLE : preload("res://scenes/vehicles/Vehicle Parts/abilities/cooldown/CooldownSimple.tscn"),
	Enums.CooldownType.MAGAZINE : preload("res://scenes/vehicles/Vehicle Parts/abilities/cooldown/CooldownMagazine.tscn")
}

func create_instance(arg_stat_calculator : StatCalculator, ability : Ability) -> CooldownInterface:
	var cooldown : CooldownInterface = cooldown_type_map[cooldown_type].instantiate()
	cooldown.stat_calculator = arg_stat_calculator
	cooldown.ability_resource = ability
	cooldown.cooldown_resource = self
	return cooldown
