local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt



-- the tabbing is annoying, might be better just to not have the fill in things and instead just output normal text that i can change after
ls.add_snippets("javascriptreact", {

    s("rule",
        fmt([[
  const {} = styled.{}`
    {}
  `;
  ]],
            {
                i(1, "Component"),
                i(2, "div"),
                i(3, "/* declarations */"),
            })
    ),

    s("rule-compose",
        fmt([[
  const {} = styled({})`
    {}
  `;
  ]],
            {
                i(1, "Component"),
                i(2, "div"),
                i(3, "/* declarations */"),
            })
    ),

    s("media",
        fmt([[
  @media ${QUERIES.<>} {
    <>
  }
  ]],
            {
                i(1, "query"),
                i(2, "/* content */"),
            },
            {
                delimiters = "<>",
            })
    ),

})
