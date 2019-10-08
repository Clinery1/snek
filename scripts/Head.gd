extends Area2D


signal score()
signal game_over()


var step:float=0.5
var delay:float=0
var body_segment=preload("res://nodes/BodySegment.tscn")
var move:Array=[true,true]
var segment:Array=[false,false]
var rand:RandomNumberGenerator=RandomNumberGenerator.new()
var adjust:bool=false
var change_rotation:bool=false
var edge_die:bool=false
var food
var last_move
var hit_food


func _ready():
    food=get_parent().get_node("Food")
    food.position=Vector2(rand.randi_range(0,102)*10,rand.randi_range(0,59)*10)

func _physics_process(delta):
    if Input.is_action_pressed("rotLeft")&&move[0]:
        rotation_degrees-=90
        move=[false,false]
        change_rotation=true
    if Input.is_action_pressed("rotRight")&&move[1]:
        rotation_degrees+=90
        move=[false,false]
        change_rotation=true
    if Input.is_action_pressed("move"):
        delay=step
    if rotation_degrees>360:
        rotation_degrees-=360
    if rotation_degrees<0:
        rotation_degrees+=360
    if delay>=step:
        var test=position+Vector2(10,0).rotated(rotation)
        if (test.x>0&&test.x<1020)&&(test.y>1&&test.y<590):
            position+=Vector2(10,0).rotated(rotation)
            if segment[0]:
                segment[1].move(last_move)
            adjust=false
        else:
            adjust=true
        move=[true,true]
        last_move=Vector2(10,0).rotated(rotation)
        delay=0
        hit_food=false
    for body in get_overlapping_bodies():
        if "BodySegment" in body.name:
            emit_signal("game_over")
            position=Vector2(200,200)
    if overlaps_body(food)&&!hit_food:
        var new_pos:Vector2=Vector2(rand.randi_range(0,102)*10,rand.randi_range(0,59)*10)
        food.position=new_pos
        emit_signal("score")
        if !segment[0]:
            segment[1]=body_segment.instance()
            get_parent().add_child(segment[1])
            segment[1].name="FirstSegment"
            segment[1].position=position-Vector2(10,0).rotated(rotation)
            segment[0]=true
        else:
            segment[1].spawn()
        hit_food=true
    if edge_die&&adjust:
        emit_signal("game_over")
        position=Vector2(200,200)
    delay+=delta

func _on_CheckButton_toggled(pressed):
    edge_die=pressed