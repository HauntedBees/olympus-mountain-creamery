class_name OfferingScene extends GameScene

@onready var main_menu: MarginContainer = %MainMenu
@onready var text_box: Label = %TextBox
@onready var god_spot: Control = %GodSpot
@onready var offer_go_prompt: VertPrompt = %OfferGoPrompt
@onready var next_prompt: VertPrompt = %NextPrompt
@onready var choice_container: CenterContainer = %ChoiceContainer
@onready var no_item: CenterContainer = %NoItem

func _ready() -> void:
	_change_state(ChooseGodState.new(self))
