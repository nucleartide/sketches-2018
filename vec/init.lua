
--
-- Vec data type.
--

local function new(x, y)
  return {x, y}
end

--
-- Get length of vector.
--

local function len(v)
  return sqrt(v.x^2 + v.y^2)
end

--
-- Get normal of vector.
--

local function normal(v)
  local l = len(v)
  return new(v.x/l, v.y/l), l
end

--
-- Export functions.
--

return {
  new = new,
  length = length,
  normal = normal,
}
