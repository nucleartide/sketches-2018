pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- jit 2018!
--
-- todo:
--
--   o side bounds
--   o coroutine will die and crash
--

--
-- utils.
--

local colors = {
  black = 0,
  dark_purple = 2,
  white = 7,
  blue = 12,
}

local sku_colors = {
  3,  -- dark green
  14, -- pink
  9,  -- orange
}

local buttons = {
  left = 0,
  right = 1,
  up = 2,
  down = 3,
  o = 4,
  z = 4,
  x = 5,
}

local config = {
  gravity = 2,
}

function intersects(
  r1_left, r1_top, -- 4, 4
  r1_right, r1_bottom, -- 5, 5

  r2_left, r2_top, -- 6, 6
  r2_right, r2_bottom -- 6, 6
)
  return not (r2_left > r1_right
    or r2_bottom < r1_top
    or r2_right < r1_left
    or r2_top > r1_bottom)
end

--
-- actors.
--

local box = {}

function box.new(x, y)
  return {
    x = x,
    y = y,
  }
end

function box.update(s)
  if btn(buttons.left) then
    s.x -= 1
  end

  if btn(buttons.right) then
    s.x += 1
  end
end

function box.draw(s)
  rectfill(
    s.x - 8, s.y - 8,
    s.x + 7, s.y + 7,
    colors.dark_purple
  )

  -- spr(n, x, y, [w, h], [flip_x], [flip_y]) -- draw sprite
  sspr(8, 0, 16, 8, s.x-8, s.y, 16, 8)

  rectfill(
    s.x, s.y,
    s.x, s.y,
    colors.white
  )
end

local sku = {}

function sku.new(x, y)
  local i = flr(rnd(3))
  local c = sku_colors[i]

  return {
    x = x,
    y = y,
    c = c,
  }
end

function sku.update(s)
  s.y += config.gravity
end

function sku.draw(s)
  rectfill(
    s.x - 4, s.y - 4,
    s.x + 3, s.y + 3,
    s.c
  )

  rectfill(
    s.x, s.y,
    s.x, s.y,
    s.c
  )
end

--
-- game loop.
--

local actors = {}

function _init()
  actors.box = box.new(64, 115)
  actors.skus = {}
end

local spawner = cocreate(function()
  for i=1,10 do
    add(actors.skus, sku.new(64, -10))

    local seconds = 2 * 60
    for i=1,seconds do
      yield()
    end
  end
end)

function _update60()
  box.update(actors.box)

  coresume(spawner)

  for s in all(actors.skus) do
    sku.update(s)

    if intersects(
      s.x, s.y, s.x+3, s.y+3,
      actors.box.x-4, actors.box.y-4, actors.box.x+3, actors.box.y+3
    ) then
      del(actors.skus, s)
    end
  end
end

function _draw()
  cls(colors.blue)

  box.draw(actors.box)

  for s in all(actors.skus) do
    sku.draw(s)
  end

  -- print(stat(0), 7)
end
__gfx__
00000000222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222272222222722200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700222222277222722200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000222272722727772200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000222272777722722200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700222272722222722200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000272272722722727200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000227722277222272200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
