local utils = require "telescope._extensions.egrepify.glob.parser"
local parser = require "telescope._extensions.egrepify.glob.parser"

-- Some ideas: https://github.com/micromatch/parse-glob/blob/HEAD/test.js
describe("Parse extension glob", function()
  it("should parse a glob with one extension", function()
    assert.same(parser.parse_glob "*.txt", { { extensions = { "txt" } } })
    assert.same(parser.parse_glob "a.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "a/b/c.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "{a,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/b/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/*/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/**/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/?/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/[abc]/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/[!abc]/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "/a/[!.abc]/{c,b}.txt", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "a/b/{c,.txt}", { { extensions = { "txt" } } })
    -- assert.same(parser.parse_glob "a/b/{c,a/b.txt}", { { extensions = { "txt" } } })
    -- a/b/{c,/.gitignore}
    -- a/b/{c,.gitignore,{a,b}}/{a,b}/abc.foo.js
  end)

  it("one extension with bracket", function()
    assert.same(parser.parse_glob "*.[0-9]", { { extensions = { "[0-9]" } } })
    assert.same(parser.parse_glob ".[0-9]", { { extensions = { "[0-9]" } } })
    assert.same(parser.parse_glob ".t[abc]t", { { extensions = { "t[abc]t" } } })
  end)

  it("one extension with multipart", function()
    assert.same(parser.parse_glob "*.min.js", { { extensions = { "min.js" } } })
    assert.same(parser.parse_glob ".min.js", { { extensions = { "min.js" } } })
  end)

  it("one extension with curly bracket", function()
    assert.same(parser.parse_glob "*.{js,mjs}", { { extensions = { "js", "mjs" } } })
  end)

  -- it("one extension without dot", function()
  -- assert.same(parser.parse_glob "*[0-9]", { { extensions = { "*[0-9]" } } })
  --   assert.same(parser.parse_glob "*txt", { { extensions = { "*txt" } } })
  -- end)
  --
  -- assert.same(parser.parse_glob "**txt", { { extensions = { "*txt" } } })
  -- it("should parse a glob with one multipart extension", function()
  --   assert.same(parser.parse_glob("*.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("a.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("a.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("a/b/c.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/b/c.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("{a,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/b/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/*/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/**/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/?/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/[abc]/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/[!abc]/{c,b}.min.js").extensions, { "min.js" })
  --   assert.same(parser.parse_glob("/a/[!.abc]/{c,b}.min.js").extensions, { "min.js" })
  -- end)

  --
  -- it("should parse a glob with multiple extensions", function()
  --   local glob_string = "*.{lua,txt}"
  -- local glob = Glob:new({
  --     extension = "json" },
  --     { extension = "lua" },
  --   }
  --
  --   assert.same(expected, utils.parse_glob(glob).extensions)
  -- end)
  --
  -- it("should parse a glob with a directory and a single extension", function()
  --   local glob_string = "lua/*.lua"
  -- local glob = Glob:new({
  --     extension = "lua" },
  --   }
  --
  --   assert.same(expected, utils.parse_glob(glob).extensions)
  -- end)
  --
  -- it("should parse a glob with a single extension and a directory", function()
  --   local glob_string = "lua/*.{lua,txt}"
  -- local glob = Glob:new({
  --     extension = "lua" },
  --     { extension = "txt" },
  --   }
  --
  --   assert.same(expected, utils.parse_glob(glob).extensions)
  -- end)
end)
