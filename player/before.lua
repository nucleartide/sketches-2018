
-- Before each evaluation of a state,
local function before(fn)
  return function(data)
    data.at += 1 -- Advance time spent in current state.
    return fn(data)
  end
end

return before
