-- Initialization
local system = {}

-- Services
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- References
local levels = workspace:WaitForChild("Levels")

-- Algorithm Functions
function calculateSpeed(difficulty: number)
	local calculatedSpeed = difficulty*10 -- Should change this how we see fit
	
	return calculatedSpeed
end

-- Actual Mechanics
function system.new(plr: Player, difficulty: number)
	local self = {}
	
	self.Map = levels:WaitForChild("Level "..difficulty)
	self.System = self.Map:WaitForChild("Core"):WaitForChild("System")
	self.WallSpeed = calculateSpeed(difficulty)
	self.Level = levels:FindFirstChild("Level "..difficulty)
	self.Difficulty = difficulty
	self.Round = 1
	
	-- Returns the doors that display the question for the player so that the script can detect which door is touched (first)
	function self:GetDoors(difficulty: number, round: number)
		if difficulty == nil or type(difficulty) ~= "number" then difficulty = self.Difficulty end
		if round == nil or type(round) ~= "number" then round = self.Round end
		
		return self.System:WaitForChild("Doors"):FindFirstChild("Part "..round):WaitForChild("Left"), self.System:WaitForChild("Doors"):FindFirstChild("Part "..round):WaitForChild("Right")
	end	
	
	-- Set up the game and clean up any leftovers
	function self:Initialize()
		print("Initializing")
		
	end
	
	-- Run a single round
	function self:Run(difficulty: number, round: number)
		if difficulty == nil or type(difficulty) ~= "number" then difficulty = self.Difficulty end
		if round == nil or type(round) ~= "number" then round = self.Round end
		
		print("Running Round "..round.." on difficulty "..difficulty)
		
		local correct = false
		
		
		local raw = self:Generate(difficulty, round)
		
		-- INSERT FUNCTION THAT ASKS QUESTION HERE --
		

		local left, right = self:GetDoors(difficulty, round)
		
		left:FindFirstChildOfClass("BillboardGui"):FindFirstChildOfClass("TextLabel").Text = raw[1]
		right:FindFirstChildOfClass("BillboardGui"):FindFirstChildOfClass("TextLabel").Text = raw[2]
		
		return correct
	end
	
	-- Clean up the game after a win or loss
	function self:End()
		print("Ending")
	end
	
	-- Run the game
	function self:Start()
		print("Starting")
		self:Initialize()
		
		local win = false
		
		for i=1, 3, 1 do
			local passed = self:Run(self.Difficulty, self.Round)
			
			if passed then
				print("User passed")
				win = true
				self.Round += 1
				
			else
				print("User failed")
				win = false
				self:End()
				
			end
		end

		return win
	end
	
	-- Generate a problem
	function self:Generate(difficulty: number, round: number)
		print("Generating Question")
		if difficulty == nil or type(difficulty) ~= "number" then difficulty = self.Difficulty end
		if round == nil or type(round) ~= "number" then round = self.Round end
		
		local problem = {
			["Question"] = "" ::string,
			["Answer"] = "" ::string,
			["Options"] = {
				
			}
		}
		
		-- Plan: To optimize depending on difficulty, make the numbers in the question have a maximum possible value and a maximum/minimum difference
		-- Example: A + B = C on difficulty X
		-- Neither A nor B can be greater than D (in harder levels also use a minimum)
		-- A - B cannot be greater than E or less than F
		-- The numbers D and F will increase based on which (of the 3) questions a player is on for progressive difficulty in each level
		
		-- ALSO: Make different operations available depending on difficulty
		
		
		local rawquestion = {} -- DO {A, B, Operation} Ex. {1, 2, "Addition"}
		local question = ""
		local answer = ""
		
		local fake_answer = ""
		
		problem.Question = question
		problem.Answer = answer
		problem.Options = {answer, fake_answer}
		
		
		return problem
	end
	
	
	return self
end

return system
