
return function(state)
  printh("evaluating fall state", "log.txt")

  -- advance state
  state.at += 1

  -- select new sprite
  state.sprite = spritewalk2

  -- advance y position
  state.y += min(4, state.at)

  -- steer left or right
  if btn(button.left) then state.x -= 1 end
  if btn(button.right) then state.x += 1 end

  -- stay in current state
  yield()

  if not canfall(state.x, state.y) then
    -- put sprite on top of tile below
    state.y = flr(state.y/8) * 8
    return idle(state)
  end

  return fall(state)
end
