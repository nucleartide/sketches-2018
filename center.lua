
local function center(printer)
  return function(str, x, y, col)
    x = x or 0
    y = y or 0

    printer(str, x+(128-4*#str), y, col)
  end
end

return center
