pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- jit 2018!
--
-- todo:
--
--   x side bounds
--   x coroutine will die and crash
--   x savings score
--   x lizzy sprite
--   x lizzy animation
--   x walking sounds
--   x lose condition
--   x leveling structure / orders
--     savings animation
--     get this on the jet website
--   x particle effects
--   x clouds in the background
--     purple SKUs
--   x item graphics
--   x boxes should fall at random spots
--   x spawn boxes next to player
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

function hcenter(s)
  -- screen center minus the
  -- string length times the
  -- pixels in a char's width,
  -- cut in half
  return 64-#s*2
end

--
-- actors.
--

local box = {}

function box.new(x, y)
  return {
    x = x,
    y = y,

    display_x = x,
    display_y = y,

    play_order_end_animation = nil,
    play_box_animation = nil,
  }
end

function box.update(s)
  if s.play_order_end_animation != nil then
    return
  end

  if s.play_box_animation != nil then
    return
  end

  if btn(buttons.left) then
    s.x -= 1
  end

  if btn(buttons.right) then
    s.x += 1
  end

  if (s.x-8) < 0 then
    s.x = 8
  end

  if (s.x+7) > 127 then
    s.x = 120
  end
end

function draw_box(x, y)
  rectfill(
    x - 8, y - 8,
    x + 7, y + 7,
    colors.dark_purple
  )
  sspr(8, 0, 16, 8, x-8, y, 16, 8)
end

function box.draw(s)
  -- spr(n, x, y, [w, h], [flip_x], [flip_y]) -- draw sprite
  if s.play_box_animation != nil or s.play_order_end_animation != nil then
    if s.play_box_animation != nil then
      coresume(s.play_box_animation, s)
    end
  else
    draw_box(s.x, s.y)
  end

  -- draw debug dot
--   rectfill(
--     s.x, s.y,
--     s.x, s.y,
--     colors.white
--   )

  -- spr(n, x, y, [w, h], [flip_x], [flip_y]) -- draw sprite
  -- spr(3, s.x, s.y+3, 2, 2) -- draw lizzy
  if s.play_order_end_animation then
    coresume(s.play_order_end_animation, s)
  else
    coresume(lizzy_walk, s)
  end
end

local sku = {}
local sku_sprites = {
  17,
  18,
  33,
  34,
  35,
  36,
  37,
  -- 38, -- can't be same color as background
  39,
  40,
  41,
  42,
  43,
}

function sku.new(x, y)
  local i = flr(rnd(3))
  local c = sku_colors[i]

  i = flr(rnd(#sku_sprites) + 1)
  local sp = sku_sprites[i]

  local is_purple = false
  if orders >= 2 then
    local r = rnd()
    if r > 0.5 then is_purple = true end
  end

  if is_purple then
    is_purple = cocreate(two_frame_anim)
  else
    is_purple = nil
  end

  return {
    x = x,
    y = y,
    c = c,
    sp = sp,
    is_purple = is_purple,
  }
end

function sku.update(s)
  -- 1
  -- 1.5
  -- 2
  if orders == 1 then
    s.y += 1
  elseif orders == 2 then
    s.y += 1.5
  elseif orders >= 3 then
    s.y += config.gravity
  end
end

function sku.draw(s)
--  rectfill(
--    s.x - 4, s.y - 4,
--    s.x + 3, s.y + 3,
--    s.c
--  )

  -- n, x, y
  spr(s.sp, s.x-4, s.y-4)

  if s.is_purple != nil then
    coresume(s.is_purple, s.x, s.y)
    -- spr(44, s.x-4, s.y-4)
  end
end

-- cocreate this for each sku
two_frame_anim = function()
  local seconds = 0.5 * 60
  local x
  local y

  while true do
    for i=1,seconds do
      x, y = yield()
      spr(44, x-4, y-4)
    end

    for i=1,seconds do
      x, y = yield()
      spr(45, x-4, y-4)
    end
  end
end

--
-- game loop.
--

local actors = {}
local savings = 0
orders = 1
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
      local box_x = actors.box.x
      local range = 25
      local new_x = box_x + flr(rnd(range * 2)) - range

      if new_x < 10 then
        new_x = 10
      end

      if new_x > 110 then
        new_x = 110
      end

      add(actors.skus, sku.new(new_x, -10))

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

-- cocreate this too
function lizzy_box_conveyor(s)
  s.display_x = s.x
  s.display_y = s.y+2

  while s.display_x < 140 do
    s.display_x += 1

    printh(s.display_x .. ' ' .. s.display_y, 'log.txt')
    draw_box(s.display_x, s.display_y)

    if (s.display_x == 140 or s.display_x == 141) then
      s.play_box_animation = nil
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
    actors.box.play_box_animation == nil and
    not created_boxes[caught_boxes / 10]
  then
    actors.box.play_order_end_animation = cocreate(lizzy_drop_box, s)
    actors.box.play_box_animation = cocreate(lizzy_box_conveyor)
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

  local text = 'game over :('
  print(text, hcenter(text), 50, 7)

  if orders == 1 then
    text = 'you ordered ' .. orders .. ' time on jet!'
    print(text, hcenter(text), 60, 7)
  else
    text = 'you ordered ' .. orders .. ' times on jet!'
    print(text, hcenter(text), 60, 7)
  end

  text = 'and you saved $' .. savings .. '!'
  print(text, hcenter(text), 70, 7)
end
__gfx__
000000002222222222222222000000044400000000000004440000006d6d6d6d0000000444000000000000044400000000000000000000000000000000000000
0000000022227222222272220000004ff44000000000004ff44000006d6d6d6d0000004ff44000000000004fff40000000000000000000000000000000000000
00700700222222277222722200000045f540000000000045f54000006d6d6d6d00000045f540000000000045f540000000000000000000000000000000000000
0007700022227272272777220000004fff4400000000004fff4400006d6d6d6d0000004fff4400000000004fff44000000000000000000000000000000000000
0007700022227277772272220f0f044fff4400000f0f044fff440000000000000000044fff4400000000044fff44000000000000000000000000000000000000
00700700222272722222722201010444f444400001010444f44440000000000000000444f444400000000444f444400000000000000000000000000000000000
00000000272272722722727200101117f714400000101117f71440000000000000000117f714400000000017f714400000000000000000000000000000000000
0000000022772227722227220001111111144000000111111114400000000000000f11f111144000000000166614400000000000000000000000000000000000
00000000000000000087770000000017771040000000001777104000000000000000001777104000000000177711400000000000000000000000000000000000
0000000000022000000777000000001666100000000000166610000000000000000000166610000000000f16661f000000000000000000000000000000000000
00000000002002000000880000000017771000000000001777100000000000000000001777100000000000177710000000000000000000000000000000000000
0000000000eeee000001110000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000022ee2200011110000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000222ff2220017710000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000222222220017710000000005050000000000000505000000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000000000011110000000050050000000000000500500000000000000000000505000000000000050500000000000000000000000000000000000000
00000000000ee0000002220000011000000220005555555500cccc00009999000007700000006000222222220000000002220000022200000000000000000000
00000000000ee000003333300000100000aaaa005bbbbbb50c0000c0099999900075570000002000222992220000000002220000027200000000000000000000
00000000000ee000003333300009900000aaaa005bbbbbb50c0000c009999990007f770000002000222222220000000002720000227220000000000000000000
00000000008888000033b3300099990000affa005bbbbbb50c0000c000f00f00007f77000000200020000002900b900022722000022200000000000000000000
0000000000888800003bbb300999999000affa005bbbbbb5cc0000cc99999999007f77000000600020000002bbbbbb9002220000002000000000000000000000
00000000008818000033b330099ff99000aaaa005bbbbbb5cc0000cc0f0000f0007f77000000600022222222bbbbbbbb00200000000000000000000000000000
000000000081880000333330099ff99000aaaa00555555550c0000c00ffffff0007f770000006000200000022222222200000000000000000000000000000000
0000000000888800003333300999999000aaaa0000055000000000000f0000f0000f700000222220200000020000000000000000000000000000000000000000
