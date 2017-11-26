
local Color = {
  Black      = 0,
  DarkBlue   = 1,
  DarkPurple = 2,
  DarkGreen  = 3,
  Brown      = 4,
  DarkGray   = 5,
  LightGray  = 6,
  White      = 7,
  Red        = 8,
  Orange     = 9,
  Yellow     = 10,
  Green      = 11,
  Blue       = 12,
  Indigo     = 13,
  Pink       = 14,
  Peach      = 15,
}

-- Test update.
function _update()
end

-- Test draw.
function _draw()
  cls()
  circfill(64, 64, 2, Color.Pink)
end

return Color
