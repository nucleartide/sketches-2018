
local function thicc(printer, border)
  return function(str, x, y, col)
    x = x or 0
    y = y or 0

    for i=-1,1 do
      for j=-1,1 do
        printer(str, x+i, y+j, border)
      end
    end

    printer(str, x, y, col)
  end
end

-- function _init()
--   local Color = require('color')
--   print = thicc(print, Color.Pink)
-- end

-- function _init()
  -- local Color = require('color', { use_game_loop = false })
-- end

-- function _update()
-- end
-- 
-- function _draw()
--   print('this text has a pink border')
-- end

return thicc
