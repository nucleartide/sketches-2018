
local button = require('picokit/button')

-- TODO: some of these vars are constants, pull them out?
local function new(x, y)
  return {
    x = x,
    y = y,

    dx = 0,
    dy = 0,

    w = 8,
    h = 8,

    max_dx = 1, -- max x speed
    max_dy = 2, -- max y speed

    jump_speed = -1.75, -- jump velocity
    acc = 0.05, -- acceleration
    air_dcc = 1, -- air deceleration
    grav = 0.15,

    jump_button = {
      is_pressed = false, -- pressed this frame
      is_down = false, -- currently down
      ticks_down = 0, -- how long down
    },

    jump_hold_time = 0, -- how long jump is held
    min_jump_press = 5, -- min time jump can be held
    max_jump_press = 15, -- max time jump can be held

    jump_btn_released = true, -- can we jump again?
    grounded = false, -- on ground
    airtime = 0, -- time since grounded

    -- animation definitions, use with set_anim()
    anims = {
      stand = {
        ticks = 1, -- how long is each frame shown
        frames = {2}, -- what frames are shown
      },

      walk = {
        ticks = 5,
        frames = {3,4,5,6},
      },

      jump = {
        ticks = 1,
        frames = {1},
      },

      slide = {
        ticks = 1,
        frames = {7},
      },
    },

    curanim = "walk", -- curently playing animation
    curframe = 1, -- current frame of animation
    animtick = 0, -- ticks until next frame should show
    flipx = false, -- should sprite be flipped
  }
end

local function update_jump_button(j)
  j.is_pressed = false

  if btn(button.x) then
    if not j.is_down then j.is_pressed = true end
    j.is_down = true
    j.ticks_down += 1
  else
    j.is_pressed = false
    j.is_down = false
    j.ticks_down = 0
  end
end

local function set_anim(p, anim)
  if anim == p.curanim then
    return
  end

  local a = p.anims[anim]
  p.curanim = anim
  p.curframe = 1
  p.animtick = a.ticks
end

local function update(p)
  -- TODO: kill enemies

  -- Track button presses.
  local bl = btn(button.left)
  local br = btn(button.right)

  -- Move left or right.

  yield()
  return update(p)
end

return {
  new = new,
}
