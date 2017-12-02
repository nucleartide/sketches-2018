
local fsm = require('fsm')
local color = require('picokit/color')
local button = require('picokit/button')
local canfall = require('util').canfall

-- construct a new ball of state
-- this be the schema
local function state()
  return {
    -- x-position in pixels
    x = 20,

    -- y-position in pixels
    y = 64,

    -- number of frames spent in current state
    at = 0,
  }
end

local idle
local walk
local jump
local fall

-- TODO: return new state
idle = function(state)
  -- advance state
  state.at += 1

  -- world wraps around horizontally
  state.x = state.x % 128

  -- and vertically...
  state.y = state.y % 128

--     if btn(button.left) or btn(button.right) then
--       return walk
--     end
-- 
--     if btn(button.up) then
--       return jump
--     end

  if canfall(state.x, state.y) then
    state.at = 0
    return fall
  end

  -- stay in current state
  yield()
  return idle(state)
end

walk = function(state)
  -- advance state
  state.at += 1

  -- stay in current state
  yield()
  return walk(state)
end

jump = function(state)
  -- advance state
  state.at += 1

  -- stay in current state
  yield()
  return jump(state)
end

fall = function(state)
  -- advance state
  state.at += 1

  -- advance y position
  state.y += min(4, state.at)

  -- stay in current state
  yield()
  return fall(state)
end

local function draw(state)
  circfill(64, 64, 40, color.pink)
  yield()
  draw(state)
end

--
-- return constructor
--

return function()
  local u, d = fsm(idle, draw, state())
  return { update = u, draw = d }
end
