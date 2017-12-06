
--
-- Module dependencies.
--

local actor = require('fsm')

--
-- Camera data type.
--

local function data()
  return {
  }
end

--
-- Camera update function.
--

--
-- Camera draw function.
--

--
-- Export constructor.
--

return {
  new = function()
    return actor.new(update, draw, data())
  end,
}
