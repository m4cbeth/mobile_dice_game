# TODO

|----------------------------WORKING ON----------------------------------------|

CREATING WOLF:
	deal option, origanize mob class structure, knights, slimes etc
	sprite and hit boxes.

|------------------------------------------------------------------------------|
|----------------------------ON MY MIND----------------------------------------|

When player adds too many knights (e.g. -gt 4):
	card destroys on enter (we have on enter set up):
		if overlapping.filter(is_knight).size() -gt 4
		destroy card in player's grip


CURR GOALS ----------------:
	Die roll, land on number, deal that many cards.
		if hand_count > max cards:
			destroy extra cards

NEXT GOALS ----------------:
	1) Die Damage and Growth:
		slimes do X damage and die changes to red die.
	NEXT BUT SAME:
		attack dice (if knights get to it)
		dice destroy...
	2) Clicking deck:
		rolls the dice
		deals cards to hand
		if more than max cards, remove random hand_count-max_count cards
	3) Sound design:
		we're missing a lot of sounds that would help:
			attack swipe
			hit splat slime
			dice hit
			card deal
			slime summon sound
	4) Invoke logic:
		color should be based not on seperate layers, but:
			controling the RAW values via dynamic code (i.e. card count body overlap)



|------------------------------------------------------------------------------|
|----------------------------DONE----------------------------------------------|
|------------------------------------------------------------------------------|



Current Bugs:
	
	Player hand location isn't correct doesn't stay centered,	
		The card isn't being removed from the array that tracks "player hand"
		also, what happens when player picks a card up from the hand? Leaves it?
		Only re enter if dropped back on deck?
	Die get's 'hit' (changes yellow red) when clicked at beginning.
	
	Knights go I don't know where when there's no slime...
		Is there a slime off screen to the left?
		They marched there and killed something before going to the dice omg lol
		Guess debugging you gotta let things play out sometimes.
		Ok they damage dice. good.













 - change "swing radius"
	- right now it's just a "distlance less than"
	- should be:
		if x < that ammount, and y < a smaller amount
		This should result in them only kinda swining on sides
	Furthermore:
		Target should be target.global_position.x +/- pxs to front of sprite
		(depending on if it's to it's left or right.')

- 
