function munpack(t, from, to)
  from = from or 1
  to = to or #t
  if from > to then return end
  return t[from], munpack(t, from+1, to)
end

function a(...)
  local t = {...}
  print(munpack(t))
end

a(1, 2, 3)
a({1, 2, 3})

-- print(munpack{1, 2, 3, 4})
