local luasnip = require("luasnip")

local snippet = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local _repeat = require("luasnip.extras").rep

luasnip.add_snippets("all", {
	snippet("note", {text("NOTE(art), " .. os.date("!%d.%m.%y") .. ": ")}),
	snippet("todo", {text("TODO(art), " .. os.date("!%d.%m.%y") .. ": ")}),
})

luasnip.add_snippets("vue", {
    snippet("vue", {
        text({
            "<script setup>",
            "import * as Vue from \"vue\";",
            "</script>",
            "",
            "<template>",
            "</template>",
            "",
            "<style scoped>",
            "</style>",
        }),
    })
})

luasnip.add_snippets("php", {
    snippet("php", {
        text({
            "<?php",
            "declare(strict_types = 1);",
            "",
            "?>"
        }),
    })
})

for _, lang in ipairs({"html", "vue", "php", "ejs", "blade"}) do
    luasnip.add_snippets(lang, {
        snippet("tag", {
            text("<"), insert(1), text(">"),
            insert(0),
            text("</"), _repeat(1), text(">")
        }),
        snippet("html", {
            text({
                "<!DOCTYPE html>",
                "<html>",
                "<head>",
                "\t<meta charset=\"utf-8\">",
                "\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
                "\t<title>Title</title>",
                "</head>",
                "<body>",
                "</body>",
                "</html>"
            })
        })
    })
end
