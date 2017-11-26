
-- https://www.lexaloffle.com/bbs/?tid=2547
local map = {
  ['normal']            = 0,
  ['2x1 aspect ratio']  = 1,
  ['tall mode']         = 2,
  ['64x64 pixels']      = 3,
  ['horizontal mirror'] = 5,
  ['reflection']        = 6,
  ['trippy']            = 7,
}

local function mode(m)
  poke(24364, map[m] or 0)
end

-- Test update.
function _update()
end

-- Test draw.
function _draw()
  cls()
end

return mode
