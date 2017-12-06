
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

  -- Jump.
  if btnp(button.o) then return next(jump, data) end

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
-- Jump state.
--

jump = function(data)
  -- Number of frames to remain in 'jump' state.
  local N = 6

  -- Speed multiplier.
  local Speed = 0.5

  -- Transition to idle if condition is met.
  if data.at > N then
    return next(idle, data)
  end

  -- Steer left or right.
  if btn(button.left) then data.x -= 1 end
  if btn(button.right) then data.x += 1 end

  -- Move.
  data.y += (data.at - N) * Speed

  -- End of frame.
  yield()

  -- Continue.
  return next(jump, data)
end

--
-- Walk state.
--

walk = function(data)
  -- Speed multiplier.
  local Speed = 0.5

  -- Transition to fall if needed.
  if canfall(data.x, data.y) then
    return next(fall, data)
  end

  -- Jump.
  if btnp(button.o) then return next(jump, data) end

  -- Transition to idle if needed.
  if not (btn(button.left) or btn(button.right)) then
    return next(idle, data)
  end

  -- Move player forward or backward
  if btn(button.left) then data.dir = -Speed end
  if btn(button.right) then data.dir = Speed end
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
