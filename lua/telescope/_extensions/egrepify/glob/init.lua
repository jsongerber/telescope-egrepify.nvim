---@class Glob
---@field paths string[]
---@field filenames string[]
---@field extensions string[]
local Glob = {}

Glob.__index = Glob

---@param paths? string[]
---@param filenames? string[]
---@param extensions? string[]
---@return Glob
function Glob:new(paths, filenames, extensions)
  local tbl = {
    paths = paths or {},
    filenames = filenames or {},
    extensions = extensions or {},
  }
  return setmetatable(tbl, Glob)
end

---@param path string
function Glob:append_path(path)
  if #self.paths == 0 then
    table.insert(self.paths, path)
  else
    for i, p in ipairs(self.paths) do
      self.paths[i] = p .. path
    end
  end
end

---@param filename string
function Glob:add_filename(filename)
  table.insert(self.filenames, filename)
end

---@param extension string
function Glob:add_extension(extension)
  table.insert(self.extensions, extension)
end

---@return Glob
function Glob:clone()
  return Glob:new()
end

return Glob
