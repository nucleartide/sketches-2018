pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- jit 2018!
--
-- todo:
--
--     side bounds
--   x coroutine will die and crash
--   x savings score
--   x lizzy sprite
--     lizzy animation
--     walking sounds
--   x lose condition
--     leveling structure / orders
--     savings animation
--     get this on the jet website
--     particle effects
--     clouds in the background
--     purple SKUs
--     item graphics
--     boxes should fall at random spots
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
    play_order_end_animation = nil,
  }
end

function box.update(s)
  if s.play_order_end_animation != nil then
    return
  end

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

  -- spr(n, x, y, [w, h], [flip_x], [flip_y]) -- draw sprite
  -- spr(3, s.x, s.y+3, 2, 2) -- draw lizzy
  if s.play_order_end_animation then
    coresume(s.play_order_end_animation, s)
  else
    coresume(lizzy_walk, s)
  end
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
local savings = 0
local orders = 0
local caught_boxes = 0

function _init()
  actors.box = box.new(64, 105)
  actors.skus = {}

  _update60 = update_game
  _draw = draw_game

  -- _update60 = update_game_over
  -- _draw = draw_game_over
end

local spawner = cocreate(function(speed)
  while true do
    for i=1,10 do
      add(actors.skus, sku.new(64, -10))

      local seconds = speed * 60
      for i=1,seconds do
        yield()
      end
    end

    while actors.box.play_order_end_animation != nil do
      yield()
    end

    orders += 1
  end
end)

lizzy_walk = cocreate(function(s)
  local seconds = 0.1 * 60
  while true do
    if btn(buttons.left) or btn(buttons.right) then
      for i=1,seconds do
        spr(3, s.x, s.y+3, 2, 2)
        yield()
      end

      for i=1,seconds do
        spr(5, s.x, s.y+3, 2, 2)
        yield()
      end
    else
      spr(5, s.x, s.y+3, 2, 2)
    end
  end
end)

-- cocreate this
function lizzy_drop_box(s)
  local seconds = 1 * 60
  for i=1,seconds do
    spr(8, s.x, s.y+3, 2, 2)
    yield()
  end

  seconds = 2 * 60
  for i=1,seconds do
    spr(10, s.x, s.y+3, 2, 2)

    if i == seconds then
      actors.box.play_order_end_animation = nil
    end

    yield()
  end
end

-- array of bools
created_boxes = {}

function update_game()
  box.update(actors.box)

  coresume(spawner, 2)

  for s in all(actors.skus) do
    sku.update(s)

    if intersects(
      s.x, s.y, s.x+3, s.y+3,
      actors.box.x-8, actors.box.y-8, actors.box.x+7, actors.box.y+7
    ) then
      del(actors.skus, s)
      savings += 10
      caught_boxes += 1
    end

    if s.y > 128 then
      _update60 = update_game_over
      _draw = draw_game_over
    end
  end

  -- printh(#(actors.skus), "log.txt")
  if
    caught_boxes > 0 and
    caught_boxes % 10 == 0 and
    actors.box.play_order_end_animation == nil and
    not created_boxes[caught_boxes / 10]
  then
    actors.box.play_order_end_animation = cocreate(lizzy_drop_box, s)
    created_boxes[caught_boxes / 10] = true
    -- printh("starting new order end anim", "log.txt")
  end
end

function draw_game()
  cls(colors.blue)

  for i=0,16 do
    spr(7, i*8, 115)
  end

  box.draw(actors.box)

  for s in all(actors.skus) do
    sku.draw(s)
  end

  print('savings: $' .. savings, 3, 3, colors.white)
  print('orders: ' .. orders, 85, 3, colors.white)
  -- print(actors.box.x ..  ' ' .. actors.box.y, 3, 20, colors.white)
  -- rect(actors.box.x-4, actors.box.y-4, actors.box.x+3, actors.box.y+3)
  -- print(stat(0), 7)
end

function update_game_over()
end

function draw_game_over()
  cls(colors.blue)
  print('game over', 30, 50, 7)
  print('you saved $' .. savings .. ' on jet!', 30, 60, 7)
end
__gfx__
000000002222222222222222000000044400000000000004440000006d6d6d6d0000000444000000000000044400000000000000000000000000000000000000
0000000022227222222272220000004ff44000000000004ff44000006d6d6d6d0000004ff44000000000004fff40000000000000000000000000000000000000
00700700222222277222722200000045f540000000000045f54000006d6d6d6d00000045f540000000000045f540000000000000000000000000000000000000
0007700022227272272777220000004fff4400000000004fff4400006d6d6d6d0000004fff4400000000004fff44000000000000000000000000000000000000
0007700022227277772272220f0f044fff4400000f0f044fff440000000000000000044fff4400000000044fff44000000000000000000000000000000000000
00700700222272722222722201010444f444400001010444f44440000000000000000444f444400000000444f444400000000000000000000000000000000000
00000000272272722722727200101117f714400000101117f71440000000000000000117f714400000000017f714400000000000000000000000000000000000
0000000022772227722227220001111111144000000111111114400000000000000f11f111144000000000111114400000000000000000000000000000000000
00000000000000000000000000000017771040000000001777104000000000000000001777104000000000177711400000000000000000000000000000000000
0000000000000000000000000000001666100000000000166610000000000000000000166610000000000f16661f000000000000000000000000000000000000
00000000000000000000000000000017771000000000001777100000000000000000001777100000000000177710000000000000000000000000000000000000
00000000000000000000000000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000000000000000000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000000000000000000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000000000000000000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000000000000000000000050050000000000000500500000000000000000000505000000000000050500000000000000000000000000000000000000
