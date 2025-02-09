extends Node2D
class_name Character

@export var character_name := ""
var emotion := ""

var target_x := 0.0

var emotions_by_page := {}

@onready var active_mat = $Sprite.get_material()

func _ready():
	ParserEvents.dialog_line_args_passed.connect(on_dialog_line_args_passed)
	add_to_group("character")
	target_x = position.x
	

func set_x_position(idx:int, time := 0, advance_instruction_after_reposition:=false):
	var position0 = 240
	var position6 = 960 - 240
	var fraction = (position6 - position0) / 7
	target_x = position0 + idx * fraction
	
	var t = create_tween()
	t.tween_property(self, "position:x", target_x, time)
	
	if advance_instruction_after_reposition and Parser.line_reader:
		t.finished.connect(Parser.line_reader.instruction_handler.instruction_completed.emit.bind())

func serialize() -> Dictionary:
	var result := {}
	
	result["visible"] = visible
	result["emotion"] = emotion
	result["target_x"] = target_x
	result["emotions_by_page"] = emotions_by_page
	result["progress"] = active_mat.get_shader_parameter("progress")
	
	return result

func deserialize(data: Dictionary):
	set_emotion(data.get("emotion", "neutral"))
	position.x = data.get("target_x", position.x)
	target_x = data.get("target_x", position.x)
	visible = data.get("visible", false)
	emotions_by_page = data.get("emotions_by_page", {})
	active_mat.set_shader_parameter("progress", data.get("progress", 0.0))

func on_dialog_line_args_passed(actor_name: String, dialog_line_args: Dictionary):
	if actor_name == character_name:
		active_mat.set_shader_parameter("progress", 0.469)
	else:
		active_mat.set_shader_parameter("progress", 0.0)
	if dialog_line_args.has(str("fade")):
		self.modulate.a = 0
		var tween = Tween.new()
		tween.tween_property(self, "modulate:a", 1, 1.2)
	if emotion != "invisible" and actor_name == character_name:
		visible = true
	if dialog_line_args.has(str(character_name, "-emotion")):
		var new_emotion : String = dialog_line_args.get(str(character_name, "-emotion"))
		emotion = new_emotion.trim_suffix("-emotion")
		set_emotion(emotion)


func set_emotion(emotion_name:String):
	emotion = emotion_name
	if emotion_name == "invisible" or emotion_name.is_empty():
		visible = false
		return
	visible = true
	find_child("Sprite").texture = load(str("res://game/characters/sprites/", character_name, "-", emotion, ".png"))

func fade_in(fade_duration:float):
	if fade_duration == 0.0:
		modulate.a = 1.0
		return
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate:a", 1.0, fade_duration).set_trans(Tween.TRANS_SINE)
	t.connect("finished", on_instruction_end_reached)

func on_instruction_end_reached():
	GameWorld.instruction_handler.instruction_completed.emit()

func _on_instruction_handler_fade_character(character_name, fade_duration):
	if character_name != self.name:
		return
	visible = true
	if modulate.a >= 0.1:
		modulate.a = 0
	fade_in(fade_duration)


func _on_instruction_handler_character_talking(active):
	if self.name != "Aenthroppe":
		return
	$Sprite/Tears.is_talking = active
	pass # Replace with function body.
