class_name MakeYogurtScene extends GameScene

@onready var boil_pot: BoilPot = %BoilPot
@onready var info_label: Label = %InfoLabel
@onready var fire: ColorRect = %Fire
@onready var temp_meter: TempMeter = %TempMeter
@onready var ice_container: IceBath = %IceContainer
@onready var yog_jars: Control = %YogJars

func _ready() -> void:
	_change_state(PourMilkState.new(self, MilkPotData.new()))
