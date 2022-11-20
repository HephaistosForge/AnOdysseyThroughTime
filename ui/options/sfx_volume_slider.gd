extends HSlider


func _process(_delta):
	value = AudioServer.get_bus_volume_db(1)


func _on_value_changed(_value):
	AudioServer.set_bus_volume_db(1, _value)
