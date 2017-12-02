
local function canfall(px, py)
  -- get the sprite number of the tile under the player
  local tile = mget(flr((px+4)/8), flr((py+8)/8))
  -- what if there's no sprite at that location?

  local can_collide = fget(tile, 0)
  return not can_collide
end

local function msg(c, s)
  if not c and s then print(s) end
  return c
end

return {
  canfall = canfall,
  msg = msg,
}
