local M = {}

function M.setup(opts)
    opts = opts or {}

    -- ----- DEFAULTS -----
    -- set template folder
    if not opts.template_folder then
        local config_path = vim.fn.stdpath('config')
        opts.template_folder = config_path .. 'templates'
    end

    -- set opts to plugin object
    M.opts = opts

    require("template.command").setup(opts)
end

return M
