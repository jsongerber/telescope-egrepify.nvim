local utils = require "telescope._extensions.egrepify.glob.parser"
local Parser = require "telescope._extensions.egrepify.glob.parser"

-- Some ideas: https://github.com/micromatch/parse-glob/blob/HEAD/test.js
describe("Parse only extension glob", function()
  it("should parse a glob with one extension", function()
    assert.same({
      { extensions = { "txt" }, filenames = {}, paths = {} },
    }, Parser.parse ".txt")
    assert.same({
      { extensions = { "txt" }, filenames = {}, paths = {} },
    }, Parser.parse ".txt")
  end)

  it("one extension with bracket", function()
    assert.same({
      { extensions = { "[0-9]" }, filenames = {}, paths = {} },
    }, Parser.parse ".[0-9]")
    assert.same({
      { extensions = { "[0-9]" }, filenames = {}, paths = {} },
    }, Parser.parse ".[0-9]")
    assert.same({
      { extensions = { "t[abc]t" }, filenames = {}, paths = {} },
    }, Parser.parse ".t[abc]t")
  end)

  it("one extension with multipart", function()
    assert.same({
      { extensions = { "min.js" }, filenames = {}, paths = {} },
    }, Parser.parse ".min.js")
    assert.same({
      { extensions = { "min.js" }, filenames = {}, paths = {} },
    }, Parser.parse ".min.js")
  end)

  it("one extension with curly bracket", function()
    assert.same({
      { extensions = { "js", "mjs" }, filenames = {}, paths = {} },
    }, Parser.parse ".{js,mjs}")
  end)

  -- it("one extension without dot", function()
  -- assert.same(parser.parse_glob "*[0-9]", {
  --   assert.same(parser.parse_glob "*txt", {
  -- end)
  --
  -- assert.same(parser.parse_glob "**txt", {
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

describe("Parse filename and paths glob", function()
  it("should parse a glob with one filename", function()
    assert.same({
      { filenames = { "test" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "test/" }, extensions = {} },
    }, Parser.parse "test")
  end)

  it("shoould parse one filename with bracket", function()
    assert.same({
      { filenames = { "[0-9]" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "[0-9]/" }, extensions = {} },
    }, Parser.parse "[0-9]")
    assert.same({
      { filenames = { "[0-9]" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "[0-9]/" }, extensions = {} },
    }, Parser.parse "[0-9]")
    assert.same({
      { filenames = { "t[abc]t" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "t[abc]t/" }, extensions = {} },
    }, Parser.parse "t[abc]t")
  end)

  it("should parse one filename with curly bracket", function()
    assert.same({
      { filenames = { "test", "lorem" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "test/", "lorem/" }, extensions = {} },
    }, Parser.parse "{test,lorem}")
  end)

  it("should parse one filename with threeaway curly bracket", function()
    assert.same({
      { filenames = { "test", "lorem", "dolor" }, paths = {}, extensions = {} },
      { filenames = {}, paths = { "test/", "lorem/", "dolor/" }, extensions = {} },
    }, Parser.parse "{test,lorem,dolor}")
  end)

  it("Should parse extension with filename", function()
    assert.same({
      { extensions = { "txt" }, filenames = { "*" }, paths = {} },
    }, Parser.parse "*.txt")
    assert.same({
      { extensions = { "txt" }, filenames = { "a" }, paths = {} },
    }, Parser.parse "a.txt")
  end)
end)
