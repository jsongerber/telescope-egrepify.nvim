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

--- Append an extension to the glob
---@param extension string: the extension to append
---@return Glob
function Glob:append_extension(extension)
  table.insert(self.extensions, extension)
  return self
end

--- Parse a glob string
---@param glob_string string: the glob
---@return Glob
M.parse_glob = function(glob_string)
  local glob = Glob:new()

  for _, ext in ipairs(vim.split(glob_string, ",")) do
    glob:append_extension(ext)
  end

  return glob
end

return Glob
