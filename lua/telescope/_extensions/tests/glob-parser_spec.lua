local utils = require "telescope._extensions.egrepify.glob.parser"
local Parser = require "telescope._extensions.egrepify.glob.parser"

-- Some ideas: https://github.com/micromatch/parse-glob/blob/HEAD/test.js
describe("Parse paths", function()
  it("should parse a simple path", function()
    assert.same({
      { paths = { "test/" }, extensions = {}, filenames = {} },
    }, Parser:new("test/"):parse())

    assert.same({
      { paths = { "lorem/ipsum/" }, extensions = {}, filenames = {} },
    }, Parser:new("lorem/ipsum/"):parse())
  end)
end)

describe("parse filenames", function()
  it("should parse a single filename", function()
    assert.same({
      { paths = {}, extensions = {}, filenames = { "lorem" } },
      { paths = { "lorem" }, extensions = {}, filenames = {} },
    }, Parser:new("lorem"):parse())
  end)
end)

describe("parse extensions", function()
  it("should parse a single extension", function()
    assert.same({
      { paths = {}, extensions = { "txt" }, filenames = {} },
    }, Parser:new(".txt"):parse())
  end)

  it("should parse a multipart extension", function()
    assert.same({
      { paths = {}, extensions = { "min.txt" }, filenames = {} },
    }, Parser:new(".min.txt"):parse())
  end)

  it("should parse an extension without a dot", function()
    assert.same({
      { paths = {}, filenames = { "*js" }, extensions = {} },
      { paths = { "*js" }, filenames = {}, extensions = {} },
      { extensions = { "*js" }, filenames = {}, paths = {} },
    }, Parser:new("*js"):parse())
  end)
end)

describe("simple globs with paths, filenames and extensions", function()
  it("should parse a simple glob with a path, filename and extension", function()
    assert.same({
      { paths = { "test/" }, extensions = { "txt" }, filenames = { "lorem" } },
    }, Parser:new("test/lorem.txt"):parse())

    assert.same({
      { paths = { "abc/test/" }, extensions = { "txt" }, filenames = { "lorem" } },
    }, Parser:new("abc/test/lorem.txt"):parse())
  end)

  it("should parse a glob with a path and a star extension", function()
    assert.same({
      { paths = { "test/" }, extensions = { "*" }, filenames = { "*" } },
    }, Parser:new("test/*"):parse())
    assert.same({
      { paths = { "test/" }, extensions = { "lua" }, filenames = { "*" } },
    }, Parser:new("test/*.lua"):parse())
  end)
end)

describe("brace extension", function()
  it("should parse extension with braces", function()
    assert.same({
      { extensions = { "js", "mjs" }, filenames = {}, paths = {} },
    }, Parser:new(".{js,mjs}"):parse())
  end)

  it("should parse filename with extension with braces", function()
    assert.same({
      { extensions = { "js", "mjs" }, filenames = { "test" }, paths = {} },
    }, Parser:new("test.{js,mjs}"):parse())
    assert.same({
      { extensions = { "js", "mjs", "txt" }, filenames = { "test" }, paths = {} },
    }, Parser:new("test.{js,mjs,txt}"):parse())

    assert.same({
      { extensions = { "js", "mjs" }, filenames = { "*" }, paths = {} },
    }, Parser:new("*.{js,mjs}"):parse())
    assert.same({
      { extensions = { "js", "mjs", "txt" }, filenames = { "*" }, paths = {} },
    }, Parser:new("*.{js,mjs,txt}"):parse())
    assert.same({
      { extensions = { "min.js", "min.mjs", "txt" }, filenames = { "*" }, paths = {} },
    }, Parser:new("*.{min.js,min.mjs,txt}"):parse())
  end)

  it("should parse filename with braces", function()
    assert.same({
      { extensions = {}, filenames = { "test", "lorem" }, paths = {} },
      { extensions = {}, filenames = {}, paths = { "test", "lorem" } },
    }, Parser:new("{test,lorem}"):parse())
    assert.same({
      { extensions = {}, filenames = { "test", "lorem", "ipsum" }, paths = {} },
      { extensions = {}, filenames = {}, paths = { "test", "lorem", "ipsum" } },
    }, Parser:new("{test,lorem,ipsum}"):parse())
  end)
end)

describe("Some optimizations", function()
  it("should show only on possibility if one of them is star", function()
    assert.same({
      { extensions = { "*" }, filenames = {}, paths = {} },
    }, Parser:new(".{js,mjs,*}"):parse())
  end)
end)

--   --
--   -- it("should parse a glob with a single extension and a path", function()
--   --   local glob_string = "lua/*.{lua,txt}"
--   -- local glob = Glob:new({
--   --     extension = "lua" },
--   --     { extension = "txt" },
--   --   }
--   --
--   --   assert.same(expected, utils.parse_glob(glob).extensions)
--   -- end)
-- end)
--
-- describe("Parse filename and paths glob", function()
--   it("should parse a glob with one filename", function()
--     assert.same({
--       { filenames = { "test" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "test/" }, extensions = {} },
--     }, Parser.parse "test")
--   end)
--
--   it("shoould parse one filename with bracket", function()
--     assert.same({
--       { filenames = { "[0-9]" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "[0-9]/" }, extensions = {} },
--     }, Parser.parse "[0-9]")
--     assert.same({
--       { filenames = { "[0-9]" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "[0-9]/" }, extensions = {} },
--     }, Parser.parse "[0-9]")
--     assert.same({
--       { filenames = { "t[abc]t" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "t[abc]t/" }, extensions = {} },
--     }, Parser.parse "t[abc]t")
--   end)
--
--   it("should parse one filename with curly bracket", function()
--     assert.same({
--       { filenames = { "test", "lorem" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "test/", "lorem/" }, extensions = {} },
--     }, Parser.parse "{test,lorem}")
--   end)
--
--   it("should parse one filename with threeaway curly bracket", function()
--     assert.same({
--       { filenames = { "test", "lorem", "dolor" }, paths = {}, extensions = {} },
--       { filenames = {}, paths = { "test/", "lorem/", "dolor/" }, extensions = {} },
--     }, Parser.parse "{test,lorem,dolor}")
--   end)
--
--   it("Should parse extension with filename", function()
--     assert.same({
--       { extensions = { "txt" }, filenames = { "*" }, paths = {} },
--     }, Parser.parse "*.txt")
--     assert.same({
--       { extensions = { "txt" }, filenames = { "a" }, paths = {} },
--     }, Parser.parse "a.txt")
--   end)
-- end)
