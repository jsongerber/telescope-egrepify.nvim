---@class Glob
---@field paths string[]
---@field filenames string[]
---@field extensions string[]
local Glob = {}

Glob.__index = Glob

function Glob:new()
  return setmetatable({
    paths = {},
    filenames = {},
    extensions = {},
  }, self)
end

---@param path string
function Glob:add_path(path)
  table.insert(self.paths, path)
end

---@param filename string
function Glob:add_filename(filename)
  table.insert(self.filenames, filename)
end

---@param extension string
function Glob:add_extension(extension)
  table.insert(self.extensions, extension)
end

return Glob
