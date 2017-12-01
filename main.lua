
local color = require('picokit/color')
local fsm = require('fsm')
local player = require('player')

local entities = {}

function _init()
  add(entities, player())
end

function _update()
  for e in all(entities) do coresume(e.update) end
end

function _draw()
  cls()
  -- sanity test: circfill(64, 64, 40, color.pink)
  for e in all(entities) do coresume(e.draw) end
end
