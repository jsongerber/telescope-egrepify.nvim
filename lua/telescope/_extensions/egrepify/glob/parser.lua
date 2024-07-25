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
  local current_glob = 1
  local globs = {
    Glob:new(),
  }
  ---@type "path" | "extension" -- We can't know if a part is a filename
  local current_part = "path"
  ---@type "path" | "extension" -- We can't know if a part is a filename
  local old_part = "path"
  local string = ""
  local maybe_extension = false
  local maybe_filename = true
  local in_braces = false
  local branch_count = 0

  for i = 1, #str do
    local char = str:sub(i, i)

    if char == "." then
      current_part = "extension"
      maybe_filename = false
    elseif char == "*" then
      maybe_extension = true
    elseif char == "/" then
      maybe_extension = false
      maybe_filename = false
    elseif char == "{" then
      in_braces = true
      branch_count = branch_count + 1
    elseif char == "}" then
      in_braces = false
    elseif current_part ~= "extension" then
      maybe_filename = true
    end

    if in_braces and char == "," then
      if "extension" == current_part then
        globs[current_glob]:add_extension(string)
      elseif "path" == current_part then
        globs[current_glob]:add_filename(string)

        if maybe_filename then
          local new_globs = M.walk_string(string .. "/")
          for _, glob in ipairs(new_globs) do
            globs[#globs + 1] = glob
          end
        end
      end
      string = ""
    end

    if
      ("." == char and "extension" == old_part and "extension" == current_part)
      or ("." ~= char and char ~= "," and char ~= "{" and char ~= "}")
    then
      string = string .. char
    end

    if i == #str or old_part ~= current_part then
      -- If we are at the end of the string, then the maybe becomes a yes
      if (i == #str and maybe_extension) or "extension" == old_part then
        globs[current_glob]:add_extension(string)
      elseif i == #str and maybe_filename then
        globs[current_glob]:add_filename(string)
        if maybe_filename then
          local new_globs = M.walk_string(string .. "/")
          for _, glob in ipairs(new_globs) do
            globs[#globs + 1] = glob
          end
        end
        -- If this is a filename, this is also a path
        -- elseif i == #str and maybe_filename then
        --   -- If this is a filename, this is also a path
        --   globs[current_glob + 1] = M.walk_string(string .. "/")
      elseif i == #str and not maybe_filename then
        globs[current_glob]:add_path(string)
      end

      string = ""

      old_part = current_part
    end

    ::continue::
  end

  return globs
end

--- Parse a glob string
---@param glob_string string: the glob
---@return Glob[]
M.parse_glob = function(glob_string)
  local globs = M.walk_string(glob_string)
  return globs
end

return M
