
--
-- badass fsm mini-framework
--

local function munpack(t, from, to)
  from = from or 1
  to = to or #t
  if from > to then return end
  return t[from], munpack(t, from+1, to)
end

local function fsm(initial_state, draw, ...)
  local args = {...}
  local u = cocreate(function() initial_state(munpack(args)) end)
  local d = cocreate(function() draw(munpack(args)) end)
  return u, d
end

return fsm
