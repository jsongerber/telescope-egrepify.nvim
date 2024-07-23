local Glob = require "telescope._extensions.egrepify.glob"

local M = {}

--- Walk a string and return the different parts of it
---@param str string: the string to walk
---@return string, string, string
---
--- Multiple globs
--- There is some case where we need to branch out and create multiple globs:
--- - *ext: can be a dirname ending with `ext` or a filename ending with `ext`
M.walk_string = function(str)
  ---@type Glob[]?
  local globs = nil
  --- 0 is not opened, 1 is maybe opened, 2 is opened
  --- This threeway boolean is because we need to handle spcial case like []]
  ---@type 0 | 1 | 1
  local is_square_bracket_open = 0
  ---@type "base" | "filename" | "extension"
  local current_part = "base"
  local is_antislash = false
  local string = ""

  for i = 1, #str do
    local char = str:sub(i, i)

    if char == "." and not is_square_bracket_open then
      current_part = "extension"
    end

    if current_part == "extension" and char ~= "." then
      extension = extension .. char
    elseif current_part == "base" then
      base = base .. char
    end
  end

  return base, filename, extension
end

--- Get the extension of a glob string
---@param glob_string string: the glob
---@return string
M.get_extension = function(glob_string)
  -- local before_extension = glob_string:match "(.+)%."
  -- local extension = vim.fn.split(glob_string, ".")[2]
  -- vim.print(vim.inspect(extension))
  -- return extension
end

--- Parse a glob string
---@param glob_string string: the glob
---@return Glob[]
M.parse_glob = function(glob_string)
  --- 0 is not opened, 1 is maybe opened, 2 is opened
  --- This threeway boolean is because we need to handle spcial case like []]
  ---@type 0 | 1 | 1
  local is_square_bracket_open = 0
  ---@type "base" | "filename" | "extension"
  local current_part = "base"
  local is_antislash = false
  local extension = ""
  local base = ""

  for i = 1, #str do
    local char = str:sub(i, i)

    if char == "[" then
      is_square_bracket_open = is_square_bracket_open + 1
    elseif char == "]" then
      is_square_bracket_open = is_square_bracket_open - 1
    end

    if char == "." and not is_square_bracket_open then
      current_part = "extension"
    end

    if current_part == "extension" and char ~= "." then
      extension = extension .. char
    elseif current_part == "base" then
      base = base .. char
    end
  end

  return base, filename, extension
end

return M
