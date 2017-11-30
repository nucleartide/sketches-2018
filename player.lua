
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
  local u, d = fsm(idle, draw, {})
  return { update = u, draw = d }
end

return new
