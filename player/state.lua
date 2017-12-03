
local canfall = require('player/canfall')
local button = require('picokit/button')

local fall
local idle
local jump
local walk

fall = function(data)
  printh("evaluating fall data", "log.txt")

  -- advance data
  data.at += 1

  -- select new sprite
  data.sprite = spritewalk2

  -- advance y position
  data.y += min(4, data.at)

  -- steer left or right
  if btn(button.left) then data.x -= 1 end
  if btn(button.right) then data.x += 1 end

  -- stay in current data
  yield()

  if not canfall(data.x, data.y) then
    -- put sprite on top of tile below
    data.y = flr(data.y/8) * 8
    return idle(data)
  end

  return fall(data)
end

idle = function(data)
  -- advance data
  data.at += 1

  -- world wraps around horizontally
  data.x = data.x % 128

  -- and vertically...
  data.y = data.y % 128

--     if btn(button.left) or btn(button.right) then
--       return walk
--     end
-- 
--     if btn(button.up) then
--       return jump
--     end

  if canfall(data.x, data.y) then
    data.at = 0
    return fall(data)
  end

  -- stay in current data
  yield()
  return idle(data)
end

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

walk = function(state)
  -- advance state
  state.at += 1

  if btn(button.left) then state.dir = -1 end
  if btn(button.right) then state.dir = 1 end
  state.x += state.dir * min(state.at, 2)

  state.sprite = spritewalk1 + flr(at/2)%2
  yield()

  if not (btn(button.left) or btn(button.right)) then
    return idle(state)
  end

  if btn(button.up) then
    return jump(state)
  end

  if canfall(state.x, state.y) then
    return fall(state)
  end

  -- stay in current state
  return walk(state)
end

--
-- Export initial state.
--

return idle
