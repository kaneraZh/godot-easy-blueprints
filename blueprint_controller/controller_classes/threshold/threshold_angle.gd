extends Threshold
class_name ThresholdAngle
@export_range(-180.0, 180.0) var value:float=0.0 : set=set_angle
var angle_radian:float
func set_angle(v:float)->void:
	value = v
	angle_radian = deg_to_rad(value)
@export_range(1.0, 360.0) var ingnore_further_than:float=180.0 : set=set_angle_ignore
var radian_ignore_top:float
var radian_ignore_bot:float
func set_angle_ignore(v:float)->void:
	ingnore_further_than = v
	if(ingnore_further_than==360.0):
		radian_ignore_top = (PI+1)
		radian_ignore_bot =-(PI+1)
	var ignore_top:float = angle_radian + deg_to_rad(ingnore_further_than)
	var ignore_bot:float = angle_radian - deg_to_rad(ingnore_further_than)
	if(ignore_top > PI):	ignore_top-= PI*2.0
	elif(ignore_bot <-PI):	ignore_bot+= PI*2.0
	radian_ignore_top = ignore_top
	radian_ignore_bot = ignore_bot
@export var allow_from_neutral = false


const PI_HALF:float = PI/2.0
func test(axis:Vector2)->int:
	var rad:float = axis.angle()
	if(	(rad > radian_ignore_top || rad < radian_ignore_bot) ||
		(allow_from_neutral && axis==Vector2()) ):
			last = signi(rad-angle_radian)
	return _process_result(rad)
