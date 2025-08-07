local keymap = vim.keymap

-- Do not yank with x
keymap.set('n', 'x', '"_x"')
-- Directory Search
keymap.set('n', '<C-p>', ':FZF<CR>')
-- Grep Directory
keymap.set('n', '<C-f>', ':Rg<CR>')
-- Git TUI
keymap.set('n', '<C-g>', ':LazyGit<CR>')
-- Undo search highlight
keymap.set('n', '<leader> ', ':nohls<CR>')
-- <F4> to highlight all trailing whitespace
keymap.set('n', '<F4>', '/\\s\\+$//e<CR>')
-- <F5> to remove all trailing whitespace
keymap.set('n', '<F5>', ':%s/\\s\\+$//e<CR>')
-- <F7 to run a node.js file
keymap.set('n', '<F7>', ':!node %<CR>')

-- Mappings for harpoon
keymap.set('n', 'fm', ':lua require("harpoon.mark").add_file()<CR>')
keymap.set('n', 'hp', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
keymap.set('n', 'f1', ':lua require("harpoon.ui").nav_file(1)<CR>')
keymap.set('n', 'f2', ':lua require("harpoon.ui").nav_file(2)<CR>')
keymap.set('n', 'f3', ':lua require("harpoon.ui").nav_file(3)<CR>')

-- Easy logging in javascript/typescript
keymap.set('n', 'cll', "yiwoconsole.log(<Esc>pF(a'<Esc>lyiwea', <Esc>pa);<Esc>")
