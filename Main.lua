local sys = require(script:WaitForChild('system'))

local e = sys.new(game.Players:WaitForChild("Roller_Bott"), 1)

local winner = e:Start()

if winner then
	print("Roller wins")
else
	print("Roller loses")
end