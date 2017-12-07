
--
-- badass fsm mini-framework
--

local function munpack(t, from, to)
  from = from or 1
  to = to or #t
  if from > to then return end
  return t[from], munpack(t, from+1, to)
end

local function msg(c, s)
  if not c and s then print(s) end
  return c
end

--
-- TODO: Rename to actor.
--

local function new(opts)
  local u = opts.update
  local d = opts.draw

  assert(type(u) == 'function')
  assert(type(d) == 'function')

  return {
    update = cocreate(function() u(opts.state) end),
    draw = cocreate(function() u(opts.state) end),
  }
end

return {
  msg = msg,
  new = new,
}
