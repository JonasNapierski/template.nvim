if 1 ~= vim.fn.has "nvim-0.9.0" then
    vim.api.nvim_err_writeln("template.nvim requires at least nvim-0.9.0")

    return
end


if vim.g.loaded_template == 1 then
    return
end

vim.g.loaded_template = 1
