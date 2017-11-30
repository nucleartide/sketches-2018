
local function munpack(t, from, to)
  from = from or 1
  to = to or #t
  if from > to then return end
  return t[from], munpack(t, from+1, to)
end

local function fsm(initial_state, draw, ...)
  local state = initial_state
  local args = {...}

  local u = cocreate(function()
    while true do state = state(munpack(args)) end
  end)

  local d = cocreate(function()
    while true do draw(munpack(args)) end
  end)

  return u, d
end

return fsm
