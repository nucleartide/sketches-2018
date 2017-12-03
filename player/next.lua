
-- Transition to next state, setting some fields in the process.
-- Assumes the existence of `data.at` and `data.state`.
local function next(state, data)
  if data.state ~= state then
    data.at = 0
    data.state = state
  else
    data.at += 1
    data.at %= 30 -- prevent overflow
  end
  return state(data)
end

return next
