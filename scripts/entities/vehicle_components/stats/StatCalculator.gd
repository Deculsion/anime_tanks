class_name StatCalculator
extends Node
## Entity component for providing up to date stat values
##
## Provides the most current values of entity stats

@export var modifier_handler : ModifierHandler

var _stat_effects : Dictionary
var _hardpoint_effects : Dictionary

func _ready():
	modifier_handler.modifier_added.connect(_on_new_modifier_added)
	modifier_handler.modifier_removed.connect(_on_modifier_removed)

	for stat in Enums.Stat.values():
		_stat_effects[stat] = {}
		
	for hardpoint in Enums.Hardpoint.values():
		_hardpoint_effects[hardpoint] = {}
		for stat in Enums.HardpointStat.values():
			_hardpoint_effects[hardpoint][stat] = {}
			
			
func get_stat(base_value : float, stat : Enums.Stat) -> float:
	return _calculate_stat(base_value, stat, -1, -1)
	
	
func get_hardpoint_stat(base_value : float, hardpoint : Enums.Hardpoint, hardpoint_stat : Enums.HardpointStat)  -> float:
	return _calculate_stat(base_value, -1, hardpoint, hardpoint_stat )
	
	
func _calculate_stat(
		base_value : float, 
		stat : Enums.Stat,
		hardpoint : Enums.Hardpoint, 
		hardpoint_stat : Enums.HardpointStat) -> float:
			
	var multipliers : Dictionary
	if stat > -1:
		multipliers = _stat_effects[stat] as Dictionary
	elif hardpoint > -1 and hardpoint_stat > -1:
		multipliers = _hardpoint_effects[hardpoint][hardpoint_stat] as Dictionary
	else:
		print("Error, invalid arguments provided to calculate_stat() at %s" % self)
		return 0
	
	var flat : float = 0.0
	var additive : float = 1.0
	var multiplicative : float = 1.0
	
	for mult in multipliers.keys():
		match mult.multiplier_type:
			Enums.StatMultiplierType.FLAT:
				flat += mult.intensity * multipliers[mult]
			Enums.StatMultiplierType.ADDITIVE:
				additive += mult.intensity * multipliers[mult]
			Enums.StatMultiplierType.MULTIPLICATIVE:
				multiplicative *= mult.intensity * multipliers[mult]
	
	return (base_value + flat) *  additive  * multiplicative
	
	
func _on_new_modifier_added(modifier : ModifierData):
	for effect in modifier.effects:
		if effect is Effect_StatMult:
			var stat_effects_dict : Dictionary = _stat_effects[effect.stat_affected]
			if stat_effects_dict.has(effect):
				stat_effects_dict[effect] += 1
			else:
				stat_effects_dict[effect] = 1
		
		elif effect is Effect_HardpointStatMult:
			var hardpoint_stat_effects_dict : Dictionary = _hardpoint_effects[effect.hardpoint_affected][effect.stat_affected]
			if hardpoint_stat_effects_dict.has(effect):
				hardpoint_stat_effects_dict[effect] += 1
			else:
				hardpoint_stat_effects_dict[effect] = 1
				
				
func _on_modifier_removed(modifier : ModifierData):
	for effect in modifier.effects:
		if effect is Effect_StatMult:
			var stat_effects_dict : Dictionary = _stat_effects[effect.stat_affected]
			if stat_effects_dict.has(effect):
				stat_effects_dict[effect] -= 1
				if stat_effects_dict[effect] == 0:
					stat_effects_dict.erase(effect)
			else:
				printerr("Error: %s tried to remove non-existent effect %s" % [self, effect])
		
		elif effect is Effect_HardpointStatMult:
			var hardpoint_stat_effects_dict : Dictionary = _hardpoint_effects[effect.hardpoint_affected][effect.stat_affected]
			if hardpoint_stat_effects_dict.has(effect):
				hardpoint_stat_effects_dict[effect] -= 1
				if hardpoint_stat_effects_dict[effect] == 0:
					hardpoint_stat_effects_dict.erase(effect)
			else:
				printerr("Error: %s tried to remove non-existent effect %s" % [self, effect])


# TEMPORARY DEBUG CODE
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_f5"):
		print("Current HP: %.2f" % get_stat(100, Enums.Stat.MAX_HP))
