class_name MakeYogurtScene extends GameScene

@onready var boil_pot: BoilPot = %BoilPot
@onready var milk_label: Label = %InfoLabel
@onready var fire: ColorRect = %Fire

func _ready() -> void:
	_change_state(PourMilkState.new(self))

func _change_state(new_state: MakeYogGameState) -> void:
	if _state:
		_state.clean()
	_state = new_state
	_state.initialize()
	_state.change_state.connect(_change_state)
