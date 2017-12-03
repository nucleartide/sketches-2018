
local player = require('player')
local fsm = require('fsm')
local entities = {}

function _init()
  add(entities, player.new())
end

function _update()
  for e in all(entities) do assert(fsm.msg(coresume(e.update))) end
end

function _draw()
  cls()
  map(0, 0, 0, 0, 16, 16) -- celx, cely, sx, sy, celw, celh
  for e in all(entities) do assert(fsm.msg(coresume(e.draw))) end
  print(stat(0))
end
