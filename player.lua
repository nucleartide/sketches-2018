
local fsm = require('fsm')

local function idle()
  print('player')
end

local function walk()
end

local function jump()
end

local function fall()
end

local function draw()
end

local function new()
  return fsm(idle, draw, {})
end

return new
