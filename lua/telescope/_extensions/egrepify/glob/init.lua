---@class Glob
---@field extensions string[]
---@field filenames string[]
local Glob = {}

Glob.__index = Glob

function Glob:new(data)
  return setmetatable({
    extensions = {},
  }, self)
end

---@param extension string
function Glob:add_extension(extension)
  table.insert(self.extensions, extension)
end

--- Append an extension to the glob
---@param extension string: the extension to append
---@return Glob
function Glob:append_extension(extension)
  table.insert(self.extensions, extension)
  return self
end

return Glob
