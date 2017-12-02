function a(...)
  local args = {...}
  return function()
    print(args)
  end
end

f = a()
f('foo', 'bar', 'baz')
