
local canfall = require('player/canfall')
local button = require('picokit/button')
local next = require('player/next')

local fall
local idle
local jump
local walk

--
-- Idle state.
--

idle = function(data)
  -- Fall.
  if canfall(data.x, data.y) then
    return next(fall, data)
  end

  -- Walk.
  if btn(button.left) or btn(button.right) then
    return next(walk, data)
  end

  -- End of frame.
  yield()

  -- Continue.
  return next(idle, data)
end

--
-- Fall state.
--

fall = function(data)
  -- If touching tile, put sprite on top of tile below.
  if not canfall(data.x, data.y) then
    data.y = flr(data.y/8) * 8
    return next(idle, data)
  end

  -- Steer left or right.
  if btn(button.left) then data.x -= 1 end
  if btn(button.right) then data.x += 1 end

  -- Fall and wrap around.
  data.y += min(4, data.at)
  data.y = data.y % 128

  -- End of frame.
  yield()

  -- Continue.
  return next(fall, data)
end

--
-- TODO: Jump state.
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
  -- Transition to fall if needed.
  if canfall(data.x, data.y) then
    return next(fall, data)
  end

  -- Transition to idle if needed.
  if not (btn(button.left) or btn(button.right)) then
    return next(idle, data)
  end

  -- Move player forward or backward
  if btn(button.left) then data.dir = -1 end
  if btn(button.right) then data.dir = 1 end
  data.x += data.dir * min(data.at, 2)
  data.x = data.x % 128

  -- End of frame.
  yield()

  -- Continue.
  return next(walk, data)
end

--
-- Export initial state.
--

return idle
