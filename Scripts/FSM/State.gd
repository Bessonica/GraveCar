extends Node
class_name State

#NOTE This is the State base-class, all our specific states inherits this logic
# DO NOT CHANGE THIS unless you know what you are doing

var isCurrent: bool

var camera: Camera3D

signal state_transition


func Enter(previousState):
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func PhysicsUpdate(_delta: float):
	pass

func Unhandled_input(event: InputEvent):
	pass

func InputInState(event: InputEvent):
	pass
	
