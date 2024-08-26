class_name MakeYogurtScene extends GameScene

@onready var boil_pot: BoilPot = %BoilPot
@onready var info_label: Label = %InfoLabel
@onready var detail_label: Label = %DetailLabel
@onready var fire: ColorRect = %Fire
@onready var temp_meter: TempMeter = %TempMeter
@onready var ice_container: IceBath = %IceContainer
@onready var yog_jars: Control = %YogJars
@onready var left_btn: VertPrompt = %LeftBtn
@onready var right_btn: VertPrompt = %RightBtn
@onready var item_list: HBoxContainer = %ItemList
@onready var none_flavor: ItemDisplay = %None
@onready var flavors: Array[ItemDisplay] = [%Honey, %Mint, %Saffron, %Pomegranate, %Walnuts]
@onready var flavor_labels: Array[Label] = [%HoneyLabel, %MintLabel, %SaffronLabel, %PomLabel, %NutLabel]
@onready var pour_hands: TextureRect = %PourHands

func _ready() -> void:
	_change_state(PourMilkState.new(self, MilkPotData.new()))
