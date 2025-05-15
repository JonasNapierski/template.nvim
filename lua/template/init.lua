local M = {}

function M.setup(opts)
    opts = opts or {}

    if not opts.template_folder then
        local config_path = vim.fn.stdpath('config')
        opts.template_folder = config_path .. '/templates'
    end

    M.opts = opts

    require("template.command").setup(opts)
end

return M
