extends "res://tests/test.gd"

const Queue := preload("res://addons/script_search/src/Queue.gd")

func test_queue():
	var max_size = 3
	var queue = Queue.new([], max_size)
	
	queue.push(1)
	assert_eq(queue.get_elements(), [1])
	
	queue.push(2)
	assert_eq(queue.get_elements(), [2, 1])
	
	queue.push(3)
	assert_eq(queue.get_elements(), [3, 2, 1])
	
	queue.push(4)
	assert_eq(queue.get_elements(), [4, 3, 2])
	
	queue.push(4)
	assert_eq(queue.get_elements(), [4, 3, 2])
	
	queue.push(2)
	assert_eq(queue.get_elements(), [2, 4, 3])
	
	queue.push(4)
	assert_eq(queue.get_elements(), [4, 2, 3])
