
-- Transition to next state, setting some fields in the process.
-- Assumes the existence of `data.at` and `data.state`.
local function transition(next_state, data)
  if data.state ~= next_state then
    data.at = 0
    data.state = next_state
  end
  return next_state(data)
end

return transition
