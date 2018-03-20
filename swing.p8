pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- player.
--
-- left-handed coordinate system. z points out of the screen.
--

function player(x, y, z)
  local this = {}

  function this.update()
    -- left.
    if btn(0) then
      x -= 1
    end

    -- right.
    if btn(1) then
      x += 1
    end

    -- up.
    if btn(2) then
      z -= 1
    end

    -- down.
    if btn(3) then
      z += 1
    end
  end

  function this.draw()
    rectfill(x, y, x+5, y+5, 7)
    print(z)
  end

  return this
end

--
-- game state.
--

entities = {}
add(entities, player(50, 50, 0))

function update_game()
  for e in all(entities) do e.update() end
end

function draw_game()
  cls(0)
  for e in all(entities) do e.draw() end
end

--
-- game loop.
--

_update60 = update_game
_draw = draw_game
