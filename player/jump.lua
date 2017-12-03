
return function(state)
  -- advance state
  state.at += 1

  state.sprite = spritewalk2

  -- move
  state.y += state.at - 6
  if btn(button.left) then state.x -= 2 end
  if btn(button.right) then state.x += 2 end

  if not btn(button.up) or state.at > 7 then
    return idle(state)
  end

  -- stay in current state
  yield()
  return jump(state)
end
