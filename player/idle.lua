
return function(state)
  -- advance state
  state.at += 1

  -- world wraps around horizontally
  state.x = state.x % 128

  -- and vertically...
  state.y = state.y % 128

--     if btn(button.left) or btn(button.right) then
--       return walk
--     end
-- 
--     if btn(button.up) then
--       return jump
--     end

  if canfall(state.x, state.y) then
    state.at = 0
    return fall(state)
  end

  -- stay in current state
  yield()
  return idle(state)
end
