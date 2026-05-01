extends Resource
class_name RS_Condition

enum _Operator {
	GREATER,
	GREATER_EGAL,
	LOWER,
	LOWER_EGAL,
	EGAL,
	NOT_EGAL,
	CONTAINS,
	EMPTY
}

@export var FirstNode: NodePath
@export var FirstProperty: String
@export var Operator: _Operator
@export var SecondNode: NodePath
@export var SecondProperty: String
@export var Constant: Variant


func Eval(owner: Node) -> bool:
	if FirstNode.is_empty() or FirstProperty.is_empty():
		return false
	
	var firstVal = owner.get_node(FirstNode).get(FirstProperty)
	var secondVal: Variant = null
	if !SecondNode.is_empty() and !SecondProperty.is_empty():
		secondVal = owner.get_node(SecondNode).get(SecondProperty)
	else:
		secondVal = Constant
	
	match Operator:
		_Operator.GREATER:
			return firstVal > secondVal
		_Operator.GREATER_EGAL:
			return firstVal >= secondVal
		_Operator.LOWER:
			return firstVal < secondVal
		_Operator.LOWER_EGAL:
			return firstVal <= secondVal
		_Operator.EGAL:
			return firstVal == secondVal
		_Operator.NOT_EGAL:
			return firstVal != secondVal
		_Operator.CONTAINS:
			if typeof(firstVal) == TYPE_STRING:
				return firstVal.contains(secondVal)
			elif firstVal.has_method("has"):
				return firstVal.has(secondVal)
			else:
				return false
		_Operator.EMPTY:
			return firstVal == null or (firstVal.has_method("is_empty") and firstVal.is_empty())
	
	return false
