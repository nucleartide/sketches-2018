pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- TODO:
--
-- - try mouse movement?
-- - antitliased movement (so when on a 0.5 point,
--   draw half shaded pixels
--

--
-- utils.
--

colors = {
  black = 0,
  dark_blue = 1,
  dark_purple = 2,
  dark_green = 3,
  brown = 4,
  dark_gray = 5,
  light_gray = 6,
  white = 7,
  red = 8,
  orange = 9,
  yellow = 10,
  green = 11,
  blue = 12,
  indigo = 13,
  pink = 14,
  peach = 15,
}

buttons = {
  left = 0,
  right = 1,
  up = 2,
  down = 3,
  o = 4,
  z = 4,
  x = 5,
}

config = {
}

sqrt2 = 1.4167

--
-- actors.
--

player = {}

function player.new(x, y)
  local self = {}

  -- diagonal movement is faster than vertical or horizontal
  function self.update()
    local dx = 0
    if btn(buttons.left) then dx -= 0.5 end
    if btn(buttons.right) then dx += 0.5 end

    local dy = 0
    if btn(buttons.up) then dy -= 0.5 end
    if btn(buttons.down) then dy += 0.5 end

    x += dx
    y += dy

    -- TODO: product tiles
  end

  function self.draw()
    rectfill(x, y, x+5, y+5, colors.dark_blue)
    print('x:'..x)
    print('y:'..y)
  end

  return self
end

spawner = {}

function spawner.new()
  local self = {}
  local boxes = {}

  for i=0,60,30 do
    for j=-200,0,40 do
      add(boxes, box.new(i,j))
    end
  end

  function self.update()
    for b in all(boxes) do b.update() end
  end

  function self.draw()
    for b in all(boxes) do b.draw() end
  end

  return self
end

box = {}

function box.new(x, y)
  local self = {}

  function self.update()
    y += 1
  end

  function self.draw()
    rectfill(x, y, x+25, y+35)
  end

  return self
end

--
-- states.
--

actors = {}

function _init()
  -- Initial state.
  _update60 = update_game
  _draw = draw_game

  -- Initialize actors.
  add(actors, player.new(64, 64))
  add(actors, spawner.new())
end

function update_game()
  for a in all(actors) do a.update() end
end

function draw_game()
  cls(colors.white)
  for a in all(actors) do a.draw() end
  print(stat(0))
end

function update_game_over()
end

function draw_game_over()
end
