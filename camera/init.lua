
--
-- Module dependencies.
--

local actor = require('fsm')
local vec = require('vec')

--
-- Camera data type.
--
-- Params:
--
--     target - actor to follow
--

local function data(target)
  -- succeeds for numbers, fails for nil
  assert(target.x)
  assert(target.y)

  return {
    tar = target,
    pos = vec(target.x, target.y),

		--how far from center of screen target must
		--be before camera starts following.
		--allows for movement in center without camera
		--constantly moving.
    pull_threshold = 16,

		--min and max positions of camera.
		--the edges of the level.
    pos_min = vec(64, 64),
    pos_max = vec(320, 64),

    -- vars for camera shake
    shake_remaining = 0,
    shake_force = 0,
  }
end

--
-- Camera draw function.
--

--
-- Get camera position.
--

local function cam_pos(c)
  local shake = vec(0,0)
  if v.shake_remaining > 0 then
    shake.x = rnd(v.shake_force) - v.shake_force/2
    shake.y = rnd(v.shake_force) - v.shake_force/2
  end
  return c.pos.x-64+shake.x, c.pos.y-64+shake.y
end

--
--
--

local function pull_max_x(self)
  return self.pos.x+self.pull_threshold
end,

--
--
--

local function pull_min_x(self)
  return self.pos.x-self.pull_threshold
end,

--
--
--

local function pull_max_y(self)
  return self.pos.y+self.pull_threshold
end,

--
--
--

local function pull_min_y(self)
  return self.pos.y-self.pull_threshold
end,

--
--
--

local function shake(c, ticks, force)
  c.shake_remaining = ticks
  c.shake_force = force
end

--
-- Camera update function.
--

local function update(c)
  c.shake_remaining = max(0, shake_remaining-1)

  -- follow target outside of pull range

  if pull_max_x(c) < c.tar.x then
    c.pos.x += min(c.tar.x - pull_max_x(c), 4)
  end

  if c.tar.x < pull_min_x(c) then
    -- TODO: use abs here
    c.pos.x += min(c.tar.x - pull_min_x(c), 4)
  end

  if pull_max_y(c) < c.tar.y then
    c.pos.y += min(c.tar.y - pull_max_y(c), 4)
  end

  if c.tar.y < pull_min_y(c) then
    -- TODO: use abs here
    c.pos.y += min(c.tar.y - pull_min_y(c), 4)
  end

  -- lock to edge
  if c.pos.x<c.pos_min.x then c.pos.x=c.pos_min.x end
  if c.pos.x>c.pos_max.x then c.pos.x=c.pos_max.x end
  if c.pos.y<c.pos_min.y then c.pos.y=c.pos_min.y end
  if c.pos.y>c.pos_max.y then c.pos.y=c.pos_max.y end
end

--
-- Export constructor.
--

return {
  new = function()
    return actor.new(update, data())

    -- TODO:
    -- infinite update :: (state) => ∞
    -- infinite draw :: (state) => ∞

    -- return actor.new{ update = update, state = data() }
  end,
}

-- camera.update
-- camera.draw
-- camera.x
