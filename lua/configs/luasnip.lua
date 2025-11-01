
local ls = require "luasnip"

print("Starting LuaSnip configuration...")

-- Add inline Rust snippets for immediate testing
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("rust", {
  s("stdin", {
    t("use std::io;"),
    t({"", "", "let mut "}), i(1, "input"), t(" = String::new();"),
    t({"", "io::stdin().read_line(&mut "}), i(2, "input"), t(")"),
    c(3, {
        t(".expect(\"Failed to read line\");"),
        t(".unwrap();"),
    }),
    t({"", "let "}), i(4, "input"), t(" = "), i(5, "input"), t(".trim();"),
    t({"", ""}), i(0),
  }),
  s("println", {
    t("println!(\""), i(1, "Hello, world!"), t("\");"),
  }),
})



