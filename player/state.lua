
local canfall = require('player/canfall')
local button = require('picokit/button')
local before = require('picokit/before')
local transition = require('picokit/transition')

local fall
local idle
local jump
local walk

--
-- Idle state.
--

idle = before(function(data)
  if canfall(data.x, data.y) then
    return transition(fall, data)
  end

  if btn(button.left) or btn(button.right) then
    return transition(walk, data)
  end

  yield()
  return transition(idle, data)
end)

--
-- Fall state.
--

fall = before(function(data)
  -- steer left or right
  if btn(button.left) then data.x -= 1 end
  if btn(button.right) then data.x += 1 end

  -- fall
  data.y += min(4, data.at)

  -- wrap around vertically
  data.y = data.y % 128

  yield()

  if not canfall(data.x, data.y) then
    -- put sprite on top of tile below
    data.y = flr(data.y/8) * 8
    return transition(idle, data)
  end

  return transition(fall, data)
end)

--
-- Jump state.
--

jump = function(state)
  -- advance state
  state.at += 1

  state.sprite = spritewalk2

  -- move
  state.y += state.at - 6
  if btn(button.left) then state.x -= 2 end
  if btn(button.right) then state.x += 2 end

  if not btn(button.up) or state.at > 7 then
    return idle(state)
  end

  -- stay in current state
  yield()
  return jump(state)
end

--
-- Walk state.
--

walk = function(data)
  -- check for fall
  if canfall(data.x, data.y) then return transition(fall, data) end

  -- check for idleness
  if not (btn(button.left) or btn(button.right)) then
    return transition(idle, data)
  end

  -- if not falling, move player forward or backward
  if btn(button.left) then data.dir = -1 end
  if btn(button.right) then data.dir = 1 end
  data.x += data.dir * min(data.at, 2)
  data.x = data.x % 128

  yield()
  return transition(walk, data)
end

--
-- Export initial state.
--

return idle
