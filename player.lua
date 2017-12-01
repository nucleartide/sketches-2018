
local fsm = require('fsm')
local color = require('picokit/color')
local button = require('picokit/button')
local canfall = require('util').canfall

-- construct a new ball of state
-- this be the schema
local function state()
  return {
    x = 20,
    y = 64,
  }
end

local idle
local walk
local jump
local fall

-- TODO: return new state
idle = function(state)
  print('player')


  while true do
    state.x = state.x % 128
    state.y = state.y % 128

    if btn(button.left) or btn(button.right) then
      return walk
    end

    if btn(button.up) then
      return jump
    end

    if canfall(state.x, state.y) then
      return fall
    end

    yield()
  end
end

walk = function()
end

jump = function()
end

fall = function()
end

local function draw()
  circfill(64, 64, 40, color.pink)
end

--
-- return constructor
--

return function()
  local u, d = fsm(idle, draw, state())
  return { update = u, draw = d }
end
