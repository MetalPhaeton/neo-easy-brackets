Neo Easy Brackets
=================

"Neo Easy Brackets" is a plugin for putting brackets easily.

Install
-------

1. Change directory to "`/home/user_dir/.config/nvim/lua`".
2. Clone this repository.
3. Write "`lua require("neo-easy-brackets"):map_insert():map_visual()`" on "`/home/user_dir/.config/nvim/init.vim`".

Features
--------

### Insert mode

* When you put an open bracket, this plugin puts a closing bracket automatically.
* If next letter is automatically put by this plugin and you try to put same letter, this plugin prevents to put the letter and move a cursor to right.
* When you delete an open bracket by backspace, this plugin deletes a closing bracket that is automatically put in same insert mode.

#### Example

![example-1](nvim_example_1.webp)

### Visual mode

* This plugin encloses selected text with each brackets.

#### Example

![example-2](nvim_example_2.webp)

### Support brackets

```
()[]{}<>''""``
```

Mapping
-------

### Insert mode

* Mapped by "`require("neo-easy-brackets"):map_insert()`"

| Mode | LHS     | RHS                                                  |
|:----:|:-------:|:-----------------------------------------------------|
| `i`  | `(`     | `luaeval('NeoEasyBracket.handle_open_parenth()')`    |
| `i`  | `)`     | `luaeval('NeoEasyBracket.handle_closing_parenth()')` |
| `i`  | `{`     | `luaeval('NeoEasyBracket.handle_open_brace()')`      |
| `i`  | `}`     | `luaeval('NeoEasyBracket.handle_closing_brace()')`   |
| `i`  | `[`     | `luaeval('NeoEasyBracket.handle_open_bracket()')`    |
| `i`  | `]`     | `luaeval('NeoEasyBracket.handle_closing_bracket()')` |
| `i`  | `<`     | `luaeval('NeoEasyBracket.handle_lt()')`              |
| `i`  | `>`     | `luaeval('NeoEasyBracket.handle_gt()')`              |
| `i`  | `'`     | `luaeval('NeoEasyBracket.handle_single_quote()')`    |
| `i`  | `"`     | `luaeval('NeoEasyBracket.handle_double_quote()')`    |
| `i`  | `"`     | `luaeval('NeoEasyBracket.handle_back_quote()')`      |
| `i`  | `<BS>`  | `luaeval('NeoEasyBracket.handle_backspace()')`       |
| `i`  | `<C-h>` | `luaeval('NeoEasyBracket.handle_backspace()')`       |
| `i`  | `<ESC>` | `luaeval('NeoEasyBracket.handle_esc()')`             |

### Visual mode

* Mapped by "`require("neo-easy-brackets"):map_visual()`"

| Mode | LHS  | RHS                                            |
|:----:|:----:|:-----------------------------------------------|
| `v`  | `(`  | `<Plug>(NeoEasyBracketEncloseWithParenth)`     |
| `v`  | `{`  | `<Plug>(NeoEasyBracketEncloseWithBrace)`       |
| `v`  | `g[` | `<Plug>(NeoEasyBracketEncloseWithBracket)`     |
| `v`  | `g<` | `<Plug>(NeoEasyBracketEncloseWithLT)`          |
| `v`  | `'`  | `<Plug>(NeoEasyBracketEncloseWithSingleQuote)` |
| `v`  | `"`  | `<Plug>(NeoEasyBracketEncloseWithDoubleQuote)` |
| `v`  | \`   | `<Plug>(NeoEasyBracketEncloseWithBackQuote)`   |

License
-------

MIT License.
