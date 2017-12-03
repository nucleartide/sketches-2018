
-- local color = require('picokit/color')
-- local fsm = require('fsm')
-- local player = require('player')
-- local msg = require('util').msg
-- local entities = {}

local player = require('player/player')

function _init()
  -- add(entities, player())
end

function _update()
  for e in all(entities) do assert(msg(coresume(e.update))) end
end

function _draw()
  cls()
  -- sanity test: circfill(64, 64, 40, color.pink)
  -- draw the map
  -- celx, cely, sx, sy, celw, celh
  map(0, 0, 0, 0, 16, 16)
  for e in all(entities) do assert(msg(coresume(e.draw))) end
  print(stat(0))
end
