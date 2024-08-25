class_name OfferingScene extends GameScene

@onready var main_menu: MarginContainer = %MainMenu
@onready var text_box: Label = %TextBox
@onready var god_spot: Control = %GodSpot
@onready var offer_go_prompt: VertPrompt = %OfferGoPrompt

func _ready() -> void:
	_change_state(ChooseGodState.new(self))
