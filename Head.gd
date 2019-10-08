extends Area2D


signal score()


var step:float=0.5
var delay:float=0
var body_segment=preload("res://BodySegment.tscn")
var move:Array=[true,true]
var segment:Array=[false,false]
var rand:RandomNumberGenerator=RandomNumberGenerator.new()
var food
var last_move


func _ready():
    food=get_parent().get_node("Food")

func _physics_process(delta):
    if Input.is_action_pressed("rotLeft")&&move[0]:
        rotation_degrees-=90
        move=[false,false]
    if Input.is_action_pressed("rotRight")&&move[1]:
        rotation_degrees+=90
        move=[false,false]
    if Input.is_action_pressed("move"):
        delay=step
    if rotation_degrees>360:
        rotation_degrees-=360
    if rotation_degrees<0:
        rotation_degrees+=360
    if delay>=step&&(0<position.x<1020):
        position+=Vector2(10,0).rotated(rotation)
        if segment[0]:
            segment[1].move(last_move)
        if overlaps_body(food):
            var new_pos:Vector2=Vector2(rand.randi_range(0,102)*10,rand.randi_range(0,59)*10)
            food.position=new_pos
            emit_signal("score")
            if !segment[0]:
                segment[1]=body_segment.instance()
                get_parent().add_child(segment[1])
                segment[1].position=position-Vector2(10,0).rotated(rotation)
                segment[0]=true
            else:
                segment[1].spawn()
        move=[true,true]
        last_move=Vector2(10,0).rotated(rotation)
        delay=0
    delay+=delta