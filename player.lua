
local fsm = require('fsm')
local color = require('picokit/color')

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
  circfill(64, 64, 40, color.pink)
end

local function new()
  local u, d = fsm(idle, draw, {})
  return { update = u, draw = d }
end

return new
