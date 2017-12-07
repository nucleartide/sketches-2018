
local player = require('player')
local fsm = require('fsm')
local entities = {}

function _init()
  add(entities, player.new())
end

function _update60()
  -- TODO: annotate message? so the entity is logged
  for e in all(entities) do
    assert(fsm.msg(coresume(e.update)) or true)
  end
end

function _draw()
  cls()
  map(0, 0, 0, 0, 16, 16) -- celx, cely, sx, sy, celw, celh
  for e in all(entities) do
    assert(fsm.msg(coresume(e.draw)) or true)
  end
  print(stat(0))
end
