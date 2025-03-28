class_name Entity_Vehicle
extends Entity

@export var health : float = 100
@export var defaultLoadout : Loadout

@onready var turret = %Turret
@onready var input = %InputController
@onready var equipmentLoadout = %EquipmentLoadout as EquipmentLoadout
@onready var modifier_handler: ModifierHandler = $ModifierHandler as ModifierHandler
@onready var health_manager: HealthManager = $HealthManager
@onready var stat_calculator: StatCalculator = $StatCalculator
#@onready var entity_detector: EntityDetector = $EntityDetector

func _ready():
	equipmentLoadout.set_equipment_loadout(defaultLoadout)


func get_barrel_aim() -> Vector3:
	return turret.get_barrel_aim()
	
	
func get_target_aim() -> Vector3:
	if input.has_method("get_current_aim"):
		return input.get_current_aim()
	return get_barrel_aim()

func get_wheels() -> Array[VehicleWheel3D]:
	var wheels : Array[VehicleWheel3D] = []
	for c in get_children():
		if c is VehicleWheel3D:
			wheels.append(c)
			
	return wheels
	
