Prompt = {}

Prompt.__index = Prompt
Prompts = {}

function Prompt:new(x, y, input)
    self.x = x
    self.y = y
    self.input = input
    self.func = func  
end