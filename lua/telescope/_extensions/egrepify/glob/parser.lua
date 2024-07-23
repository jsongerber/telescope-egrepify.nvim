local Glob = require "telescope._extensions.egrepify.glob"

local M = {}

--- Walk a string and return the different parts of it
---@param str string: the string to walk
---@return Glob[]
---
--- Multiple globs
--- There is some case where we need to branch out and create multiple globs:
--- - *ext: can be a dirname ending with `ext` or a filename ending with `ext`
M.walk_string = function(str)
  -- local globs = {}
  local glob = Glob:new()
  ---@type "base" | "filename" | "extension"
  local current_part = "base"
  ---@type "base" | "filename" | "extension"
  local old_part = "base"
  local string = ""
  local maybe_extension = false
  local in_bracket = false

  for i = 1, #str do
    local char = str:sub(i, i)

    if char == "." then
      current_part = "extension"
    elseif char == "*" then
      maybe_extension = true
    elseif char == "/" then
      maybe_extension = false
    elseif char == "{" then
      in_bracket = true
    elseif char == "}" then
      in_bracket = false
    end

    string = string .. char

    if i == #str or old_part ~= current_part then
      -- If we are at the end of the string, then the maybe becomes a yes
      if i == #str and maybe_extension then
        glob:add_extension(string)
      elseif "extension" == old_part then
        glob:add_extension(string)
      end

      string = ""

      old_part = current_part
    end
  end

  return { glob }
end

--- Parse a glob string
---@param glob_string string: the glob
---@return Glob[]
M.parse_glob = function(glob_string)
  local globs = M.walk_string(glob_string)
  return globs
end

return M
