extends Node

# TODO: replace interface with a single `enum` DIR8
enum DIR8{
	N,
	NE,
	E,
	SE,
	S,
	SW,
	W,
	NW
}

enum DIR4{
	N,
	E,
	S,
	W
}

# Alias
var LEFT = DIR8.W
var RIGHT = DIR8.E
var DOWN = DIR8.S
var UP = DIR8.N