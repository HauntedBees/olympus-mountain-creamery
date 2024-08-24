class_name MakeYogurtScene extends GameScene

@onready var boil_pot: BoilPot = %BoilPot
@onready var milk_label: Label = %InfoLabel
@onready var fire: MarginContainer = %FireContainer

func _ready() -> void:
	_state = PourMilkState.new(self)

func _process(delta: float) -> void:
	_state.update(delta)
