local Glob = require "telescope._extensions.egrepify.glob"

---@class ParserState table
---@field escape boolean: If the next character should be escaped

---@class Parser
---@field raw string: The raw string to parse
---@field globs Glob[]: The globs that came out of the raw string
---@field state ParserState: The state of the parser
local Parser = {}

Parser.__index = Parser

function Parser:new(raw)
  return setmetatable({
    raw = raw,
    state = {},
    globs = {
      Glob:new(),
    },
  }, self)
end

---@return Glob[]
---
--- Multiple globs
--- There is some case where we need to branch out and create multiple globs:
--- - *ext: can be a dirname ending with `ext` or a filename ending with `ext`
---
--- Weird cases:
--- {test\,lorem} matches nothhing, but {test\,lorem,} matches `test,lorem`
function Parser:parse()
  ---@type "path" | "extension" -- We can't know if a part is a filename
  local current_type = "path"

  for i = 1, #self.raw do
    local char = self.raw:sub(i, i)

    if self.state.escape then
      self.state.escape = false
      self:handle_default(char)
    elseif char == "\\" then
      self:handle_backslash()
    elseif char == "/" then
      self:handle_slash()
    elseif char == "{" then
      self:handle_brace()
    elseif char == "}" then
      self:handle_brace_end()
    elseif char == "," then
      self:handle_comma()
    elseif char == ":" then
      self:handle_colon()
    elseif char == "*" then
      self:handle_star()
    else
      self:handle_default(char)
    end
  end

  return self.globs
end

function Parser:handle_backslash()
  local state = self.state
  local current_glob = self.globs[#self.globs]

  current_glob:add_path "\\"
  state.escape = true
end

-- A slash cannot be in an extension
function Parser:handle_slash()
  local current_glob = self.globs[#self.globs]

  if self.state.escape then
    self.state.escape = false
  end

  current_glob:add_path "/"
end

return Parser
