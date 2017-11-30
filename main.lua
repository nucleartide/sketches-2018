
local color = require('picokit/color')
local fsm = require('fsm')
local player = require('player')

local entities = {}

function _init()
  add(entities, player.new())
end

function _update()
end

function _draw()
  cls()
  circfill(64, 64, 40, color.pink)
end
