local Glob = require "telescope._extensions.egrepify.glob"

---@class ParserState table
---@field escape boolean: If the next character should be escaped
---@field current_string string: The current string being built
---@field had_dot boolean: If the current string had a dot
---@field star_pos number: The position of the star (-1 if not present)

---@class Parser
---@field raw string: The raw string to parse
---@field globs Glob[]: The globs that came out of the raw string
---@field state ParserState: The state of the parser
local Parser = {}

Parser.__index = Parser

function Parser:new(raw)
  return setmetatable({
    raw = raw,
    state = {
      escape = false,
      current_string = "",
      had_dot = false,
      star_pos = -1,
    },
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
--- Some rules:
--- Braces need a comma, {test} is invalid {test,} or {,test} is valid
function Parser:parse()
  for i = 1, #self.raw do
    local char = self.raw:sub(i, i)

    if char == "\\" then
      self:handle_backslash()
    elseif char == "." then
      self:handle_dot()
    elseif char == "*" then
      self:handle_star(i)
    elseif char == "/" then
      self:handle_slash()
    elseif char == "{" then
      self:handle_brace_start()
    elseif char == "}" then
      self:handle_brace_end()
    elseif char == "," then
      self:handle_comma()
    elseif char == ":" then
      self:handle_colon()
    else
      self:handle_default(char)
    end

    if i == #self.raw then
      self:handle_end()
    end
  end

  return self.globs
end

function Parser.handle_default(self, char)
  self.state.current_string = self.state.current_string .. char
end

function Parser:handle_slash()
  local current_glob = self.globs[#self.globs]
  current_glob:append_path(self.state.current_string .. "/")

  self.state.current_string = ""
end

function Parser:handle_dot()
  local current_glob = self.globs[#self.globs]

  -- We already had a dot, so this is probably a multipart extension
  if self.state.had_dot then
    self.state.current_string = self.state.current_string .. "."
    return
  end

  if self.state.current_string ~= "" then
    current_glob:add_filename(self.state.current_string)
  end

  self.state.had_dot = true

  self.state.current_string = ""
end

---@param i number: The position of the star
function Parser:handle_star(i)
  self.state.star_pos = i

  self.state.current_string = self.state.current_string .. "*"

  if i == #self.raw then
    vim.print(vim.inspect "add filename 1")
    self.globs[#self.globs]:add_extension(self.state.current_string)
    self.globs[#self.globs]:add_filename(self.state.current_string)
    self.state.current_string = ""
  end
end

function Parser:handle_end()
  if self.state.current_string == "" then
    return
  end

  if self.state.had_dot then
    self.globs[#self.globs]:add_extension(self.state.current_string)
  else
    self.globs[#self.globs]:add_filename(self.state.current_string)

    local new_glob = self.globs[#self.globs]:clone()
    new_glob:append_path(self.state.current_string)

    table.insert(self.globs, new_glob)

    if self.state.star_pos ~= -1 then
      -- Has no star
      local new_extension_glob = self.globs[#self.globs]:clone()
      new_extension_glob:add_extension(self.state.current_string)

      table.insert(self.globs, new_extension_glob)
    end
  end

  self.state.current_string = ""
end

function Parser:handle_brace_start() end

function Parser:handle_brace_end()
  self:handle_end()
end

function Parser:handle_comma()
  self:handle_end()
end

return Parser
