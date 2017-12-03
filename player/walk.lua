
return function(state)
  -- advance state
  state.at += 1

  if btn(button.left) then state.dir = -1 end
  if btn(button.right) then state.dir = 1 end
  state.x += state.dir * min(state.at, 2)

  state.sprite = spritewalk1 + flr(at/2)%2
  yield()

  if not (btn(button.left) or btn(button.right)) then
    return idle(state)
  end

  if btn(button.up) then
    return jump(state)
  end

  if canfall(state.x, state.y) then
    return fall(state)
  end

  -- stay in current state
  return walk(state)
end
