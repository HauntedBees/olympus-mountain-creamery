class_name PlayerData extends Resource

const JAR_CAPACITY := 5.0

## How much milk the player has.
@export var milk_amount := 30.0

## It's money.
@export var money := 20

## How much milk fits in the player's pot.
@export var milk_pot_capacity := 15.0

## The number of jars available for yogurt-filling.
@export var jars := 10

## How much strength the player has in their arm.
@export var arm_energy := 5.0

## Amount of arm energy recovered per second.
@export var arm_recovery_rate := 0.5

## The player's actively fermenting yogurt jars.
@export var yogurts: Array[MilkPotData] = []
