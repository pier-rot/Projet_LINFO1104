local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:red name:gordon
			   positions: [pos(x:11 y:13 to:west) pos(x:12 y:13 to:west) pos(x:13 y:13 to:west) pos(x:14 y:13 to:west) pos(x:14 y:12 to:south) pos(x:14 y:11 to:west) pos(x:14 y:10 to:south)]
			   effects: nil
			   strategy: [forward forward repeat([forward] times:30) turn(left) forward  forward turn(left) forward turn(left) repeat([forward] times:6) turn(left) forward turn(left) repeat([forward] times:6) turn(left) forward turn(left) repeat([forward] times:10)]
			   seismicCharge: NoBomb
			   sleep: 0
			  )

			  spaceship(team:green name:oui
			   positions: [pos(x:3 y:4 to:south) pos(x:3 y:3 to:south)]
			   effects: nil
			   strategy: [forward forward repeat([forward] times:17) turn(left) repeat([forward] times:19) turn(left) repeat([forward] times:19) turn(left) repeat([forward] times:19)turn(left) repeat([forward] times:19) turn(left) repeat([forward] times:19) turn(left) repeat([forward] times:17)]
			   seismicCharge: NoBomb
			   sleep: 0
			  )
		    ]
	    bonuses: [
		    bonus(position:pos(x:13 y:12) color:orange effect:wormhole(x:8 y:13) target:catcher)
		    bonus(position:pos(x:8 y:13)  color:orange effect:wormhole(x:13 y:12) target:catcher)
			bonus(position:pos(x:4 y:12) color:red effect:revert target:catcher)
			bonus(position:pos(x:15 y:13) color:blue effect:emb(n:3) target:catcher)
			bonus(position:pos(x:18 y:13) color:purple effect:shrink(n:4) target:catcher)
			bonus(position:pos(x:3 y:23) color:yellow effect:scrap target:catcher)
			bonus(position:pos(x:23 y:23) color:yellow effect:scrap target:catcher)
			bonus(position:pos(x:23 y:3) color:yellow effect:scrap target:catcher)
	    ]
	    bombs: [
		    bomb(position:pos(x:15 y:12) explodesIn:3)
		    bomb(position:pos(x:9 y:8) explodesIn:6)]
	   )
end