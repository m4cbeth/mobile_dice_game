should I...:
	- change the behavior of mobs to
	if thing is above horizon:
		target(thing.x, horizon)?
I don't know:
	what is it currently doing now?

# DICK DECK
> on ready, add three-5 cards slighty skewed and shifted
var thingy = get_parent().get_node("Group/Coin")
var thingyTwo = thingy.duplicate()
thingyTwo.position.x = 0
someNode.addchild(thingyTwo)
[don't forget ^^^^ to add to as child to a node]

# PlAYER HAND
	add card rotation.
