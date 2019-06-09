extends Node

var tankPosition = Vector2()

static func is_bit_enabled(mask, index):
    return mask & (1 << index) != 0

static func enable_bit(mask, index):
    return mask | (1 << index)

static func disable_bit(mask, index):
    return mask & ~(1 << index)