-- MIT License
-- 
-- Copyright 2021 Hironori Ishibashi
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.

local M = {}

NeoEasyBracket = {}

local ch_stk = {}

local left_code = "<Left>";
local input_text_table = {
    ["("] = "()" .. left_code,
    ["{"] = "{}" .. left_code,
    ["["] = "[]" .. left_code,
    ["<"] = "<>" .. left_code,
    ["'"] = "''" .. left_code,
    ['"'] = '""' .. left_code,
    ['`'] = '``' .. left_code,
}

local ch_pair_table = {
    ["("] = ")",
    ["{"] = "}",
    ["["] = "]",
    ["<"] = ">",
    ["'"] = "'",
    ['"'] = '"',
    ['`'] = '`',
}

local ch_r_pair_table = {
    [")"] = "(",
    ["}"] = "{",
    ["]"] = "[",
    [">"] = "<",
    ["'"] = "'",
    ['"'] = '"',
    ['`'] = '`',
}

local function handle_open(ch)
    table.insert(ch_stk, ch_pair_table[ch])
    return input_text_table[ch]
end

local right_code = "<Right>";
local function handle_close(ch)
    local pos = vim.fn.getcurpos()
    local row = pos[2]
    local col = pos[3]
    local line = vim.fn.getline(row)
    local ch_2 = line:sub(col, col)

    if (#ch_stk > 0) and (ch_2 == ch) and (ch_stk[#ch_stk] == ch) then
        table.remove(ch_stk)
        return right_code
    else
        return ch
    end
end

local function handle_quote(ch)
    if ch_stk[#ch_stk] == ch then
        return handle_close(ch)
    else
        return handle_open(ch)
    end
end

function NeoEasyBracket.handle_backspace()
    local pos = vim.fn.getcurpos()
    local row = pos[2]
    local col = pos[3]
    local line = vim.fn.getline(row)
    local prev_col = col - 1
    local prev_ch = line:sub(prev_col, prev_col)

    if (#ch_stk > 0) and (ch_pair_table[prev_ch] == ch_stk[#ch_stk]) then
        table.remove(ch_stk)
        return "<Del><BS>"
    else
        return "<BS>"
    end
end

function NeoEasyBracket.handle_esc()
    for i in pairs(ch_stk) do
        ch_stk[i] = nil
    end
    return "<ESC>"
end


function NeoEasyBracket.handle_open_parenth() return handle_open("(") end
function NeoEasyBracket.handle_open_brace() return handle_open("{") end
function NeoEasyBracket.handle_open_brcket() return handle_open("[") end
function NeoEasyBracket.handle_lt() return handle_open("<") end

function NeoEasyBracket.handle_closing_parenth() return handle_close(")") end
function NeoEasyBracket.handle_closing_brace() return handle_close("}") end
function NeoEasyBracket.handle_closing_bracket() return handle_close("]") end
function NeoEasyBracket.handle_gt() return handle_close(">") end

function NeoEasyBracket.handle_single_quote() return handle_quote("'") end
function NeoEasyBracket.handle_double_quote() return handle_quote('"') end
function NeoEasyBracket.handle_back_quote() return handle_quote("`") end

function M:map_insert()
    vim.keymap.set(
        "i",
        "(",
        "luaeval('NeoEasyBracket.handle_open_parenth()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        ")",
        "luaeval('NeoEasyBracket.handle_closing_parenth()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "{",
        "luaeval('NeoEasyBracket.handle_open_brace()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "}",
        "luaeval('NeoEasyBracket.handle_closing_brace()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "[",
        "luaeval('NeoEasyBracket.handle_open_brcket()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "]",
        "luaeval('NeoEasyBracket.handle_closing_bracket()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "<",
        "luaeval('NeoEasyBracket.handle_lt()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        ">",
        "luaeval('NeoEasyBracket.handle_gt()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "'",
        "luaeval('NeoEasyBracket.handle_single_quote()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        '"',
        "luaeval('NeoEasyBracket.handle_double_quote()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "`",
        "luaeval('NeoEasyBracket.handle_back_quote()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "<BS>",
        "luaeval('NeoEasyBracket.handle_backspace()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "<C-h>",
        "luaeval('NeoEasyBracket.handle_backspace()')",
        {noremap = true, expr = true}
    )

    vim.keymap.set(
        "i",
        "<ESC>",
        "luaeval('NeoEasyBracket.handle_esc()')",
        {noremap = true, expr = true}
    )

    return self
end

local function get_succ_col(row_num, col_num)
    local line = vim.fn.getline(row_num)
    local char_idx = vim.fn.charidx(line, col_num)
    local byte_idx = vim.fn.byteidx(line, char_idx)

    if col_num == byte_idx then
        return col_num + 1
    else
        return vim.fn.byteidx(line, char_idx + 1) + 1
    end
end

local function enclose_with(ch)
    local pos_s = vim.fn.getpos("'<")
    local row_s = pos_s[2]
    local col_s = pos_s[3]

    local line_s = vim.fn.getline(row_s)

    local pos_e = vim.fn.getpos("'>")
    local row_e = pos_e[2]
    local succ_col = get_succ_col(row_e, pos_e[3])

    if vim.fn.visualmode() == "V" then
        vim.fn.setline(row_s, ch .. line_s)

        local line_e = vim.fn.getline(row_e)
        ch = ch_pair_table[ch]
        vim.fn.setline(row_e, line_e .. ch)

        vim.fn.setpos(".", pos_s)
        vim.fn.execute("normal V")
        vim.fn.setpos(".", pos_e)
    else
        vim.fn.setline(
            row_s,
            line_s:sub(1, col_s - 1) .. ch .. line_s:sub(col_s)
        )

        if row_s == row_e then
            succ_col = succ_col + 1
        end

        local line_e = vim.fn.getline(row_e)
        ch = ch_pair_table[ch]
        vim.fn.setline(
            row_e,
            line_e:sub(1, succ_col - 1) .. ch .. line_e:sub(succ_col)
        )

        vim.fn.setpos(".", pos_s)
        vim.fn.execute("normal v")
        pos_e[3] = succ_col
        vim.fn.setpos(".", pos_e)
    end
end

function NeoEasyBracket.enclose_with_parenth() return enclose_with("(") end
function NeoEasyBracket.enclose_with_brace() return enclose_with("{") end
function NeoEasyBracket.enclose_with_bracket() return enclose_with("[") end
function NeoEasyBracket.enclose_with_lt() return enclose_with("<") end
function NeoEasyBracket.enclose_with_single_quote()
    return enclose_with("'")
end
function NeoEasyBracket.enclose_with_double_quote()
    return enclose_with('"')
end
function NeoEasyBracket.enclose_with_back_quote()
    return enclose_with("`")
end

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithParenth)",
    ":<C-u>lua NeoEasyBracket.enclose_with_parenth()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithBrace)",
    ":<C-u>lua NeoEasyBracket.enclose_with_brace()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithBracket)",
    ":<C-u>lua NeoEasyBracket.enclose_with_bracket()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithLT)",
    ":<C-u>lua NeoEasyBracket.enclose_with_lt()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithSingleQuote)",
    ":<C-u>lua NeoEasyBracket.enclose_with_single_quote()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithDoubleQuote)",
    ":<C-u>lua NeoEasyBracket.enclose_with_double_quote()<CR>",
    {silent = true, noremap = true}
)

vim.keymap.set(
    "v",
    "<Plug>(NeoEasyBracketEncloseWithBackQuote)",
    ":<C-u>lua NeoEasyBracket.enclose_with_back_quote()<CR>",
    {silent = true, noremap = true}
)

function M:map_visual()
    vim.keymap.set(
        "v",
        "(",
        "<Plug>(NeoEasyBracketEncloseWithParenth)",
        {}
    )

    vim.keymap.set(
        "v",
        "{",
        "<Plug>(NeoEasyBracketEncloseWithBrace)",
        {}
    )

    vim.keymap.set(
        "v",
        "g[",
        "<Plug>(NeoEasyBracketEncloseWithBracket)",
        {}
    )

    vim.keymap.set(
        "v",
        "g<",
        "<Plug>(NeoEasyBracketEncloseWithLT)",
        {}
    )

    vim.keymap.set(
        "v",
        "'",
        "<Plug>(NeoEasyBracketEncloseWithSingleQuote)",
        {}
    )

    vim.keymap.set(
        "v",
        "\"",
        "<Plug>(NeoEasyBracketEncloseWithDoubleQuote)",
        {}
    )

    vim.keymap.set(
        "v",
        "`",
        "<Plug>(NeoEasyBracketEncloseWithBackQuote)",
        {}
    )

    return self
end

return M
