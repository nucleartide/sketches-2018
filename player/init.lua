
--
-- Module dependencies.
--

local fsm = require('fsm')
local state = require('player/state')

--
-- Constants.
--

local spritewalk1 = 17
local spritewalk2 = 18
local spritewalk3 = 19

--
-- Player data type.
--

local function data()
  return {
    -- x-position in pixels
    x = 10,

    -- y-position in pixels
    y = 64,

    -- number of frames spent in current state
    -- range is [0, 30), see next.lua
    at = 0,

    -- current sprite index
    sprite = 0,

    -- current direction
    dir = 0,

    -- current state
    state = state,
  }
end

--
-- Player draw function.
--

local function draw(data)
  -- TODO: flip sprite?
  spr(spritewalk1, data.x, data.y)
  print('x:' .. data.x)
  print('at:' .. data.at)
  yield()
  return draw(data)
end

--
-- Export constructor.
--

return {
  new = function()
    local u, d = fsm.new(state, draw, data())
    return { update = u, draw = d }
  end,
}
