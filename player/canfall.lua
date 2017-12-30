
--
-- Test whether player can collide with tile below.
--

return function(px, py)
  local tile = mget(flr((px+4)/8), flr((py+8)/8))
  local can_collide = fget(tile, 0)
  return not can_collide
end
