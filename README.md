# bbmoba2d
A top-down 2D MOBA built with Godot engine :o

![Freddy](https://www.cs.mcgill.ca/~jma229/images/freddy-walk.gif)
![Jacky](https://github.com/jackymayo/bbmoba2d/blob/fred/Assets/beebois/jacky/jacky-attack.gif)
## Getting started


For now, I think we should get the map environment and player controls down. Any input you guys have on the workflow we could have would be nice. IMO, everyone should work on a bit of everything so we can get that maximum EXPOSURE.

### Brief extension info

- **.tscn**, **.scn**: scene files containing all the project files. **USE TSCN** because
it's text-based and can be version controlled (*same applies for anything else that starts with a t*). In addition, there's a TileSets.tscn used to refresh the tilsets that we could load. 
[More info here](http://docs.godotengine.org/en/latest/tutorials/2d/using_tilemaps.html)
- **.tres**: Resource files. TileSets.tscn can be converted to a .tres. This could then be used to load into a Tilemap object.
- **.gd**: Basic GDScript file.

### File structure

Check each folder for some more getting started associated with this.

1. Assets (Sprites/Tiles/Animations)
	- Obstacles: Tiles that have a collision on them
	- Tiles: Tiles that don't have a collision on them (Might need to remove some)
2. Scenes: Basically any objects that we want to define along with the map
3. Scripts: GD scripts
4. Resources: For now all we have are the compiled tilesets.


## Tyguy ideas

### Maxim, macro AA-focused character:

- **Passive:** Helpful Maxim, on death he creates a helpful maxim until he revives that can only clear minions

- **A:** Maxsnuzyen, Self-immobilize for 2 seconds, regain 50% over time or until hit

- **B:** Overly Precise, Correct a semantic error of the opponents, causing the annoyance debuff(taunts them but reduces their auto damage by 50%)

- **Ult:** MaxstayingupforLCK, get a timed buff that revives on death immediately. (Can only be cast Out of Combat?)

- **Mine:** SC1 Vulture Mine, hidden in the ground, moves towards a nearby enemy and explodes for AoE damage


### Jacky, poke character:

- **Passive:** Why you gotta expose me, when not exposed, gains stats. Getting hit by an opponent's ability exposes jacky for 2 seconds

- **A:** Public Bee Fly, a line skill shot that can hit minions. Deals damage and has a chance of inflicting the “bee fly in public setting” debuff (cannot go invisible)

- **B:**  Discord Bee Fly, a line skillshot that can hit minions. Deals damage and hitting a champ reduces cooldown of Public Bee Fly.

- **Ult:** Blessed by Bee Fly. Summon a bee for each Public Bee Fly that hit an enemy character

- **Mine:** OMEGALUL trap, super small explosion AoE, long arm time. If it connects it reduces that character’s vision

 
### Fredy, all in clown fiesta character:

- **Passive 1:** POGGERS, Every kill increases attack stat.

- **Passive 2:** MonkaFRICKENs: Every death reduces max health

- **A:** Hmmmmm, point and click debuff (Confuses enemy, aka OG fear in league)

- **B:** Going to Stanford, point and click arcane shift that damages everything around

- **Ult:** Summon Wai Lun, summons a ranged ally (Basically a ranged helpful maxim) that attacks whatever Fredy is targeting. Can only be one Wai Lun at a time.

- **Mine:** Duckatown misc mine, Answer three random prompts in character select. The choices are based of duckatown prompts and it chooses whether it’s a heal, slow, speed up or damage. Or fake tree trap #S

 
### Sam, assassin:

- **Passive:** Suddenly MIA, Whenever the clock hits X:00 Sam gains invisibility for 5 seconds or until he attacks a unit

- **A:** Hits you with the Hard R, empowered auto that slows movement by 35% (because you feel REAL uncomfortable)

- **B:** Dead Cellphone: Passive, if an enemy would attack you, 10% of missing

- **Ult:** Sudden Roast, Point and click execute that applies the exposed status, and if already exposed deals more damage

- **Mine:** Megapolis trap, Stepping on it stuns the enemy as they are lost in Sam’s highway infrastructure


### Tyler, Buff/Debuff Support:

- **Passive:** SBTyguy, Can deny his own minions to give opponent exposed status (gives reduced gold to enemy and must be down at >5% hp)

- **A:** Deletes your messages: Point and click silence

- **B:** Ardent Censor abuser: Heals every ally unit within the AOE and gives the FGM buff (10% buff to resistances)

- **Ult:** Labatt 50, empowers himself or an ally, increasing their range, damage and health

- **Mine:** MsPaint Surprise trap, sends out an “skill shot” in every cardinal point, bomberman style

## Concepts

- Ult available from the beginning, but using it removes your passive. Can only ult for as many passives as you have

- Players get passively stronger as game progresses

- Forest on the sides of the lane, breaking down trees provides lumber which can be used to buy an assortment of items/consumables

- Every combination of characters should provide a small team boost


## Items to buy:

- Small turret
- Scrolls, one time spells (heal, buff, debuff, dot)
- Fake-tree, basically a ward


## Contributing on Sprites

1. Create a folder of the category for the sprite if it doesn't exist.
2. Character size: 64x64, Tile size: 16x16
3. Make sure tiles have edges link
4. Load it into the TileSets.tscn. [More info here](http://docs.godotengine.org/en/latest/tutorials/2d/using_tilemaps.html)

## Ideas
- Every character being able to charge up for the same buff, something like X% more attack speed or movement speed, getting hit
delays or cancels the channel
