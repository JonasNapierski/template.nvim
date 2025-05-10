local M = {}
local header = require("template.header")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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
end

function M.helloWorld()
    print("Hello World")
end



local function get_templates_from_folder(folder_path)
    local templates = {}
    local handle = vim.loop.fs_scandir(vim.fn.expand(folder_path))

    if handle then
        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if type == "file" then
                table.insert(templates, name)
            end
        end
    else
        print("Folder not found: " .. folder_path)
    end

    return templates
end

local function select_template(opts, callback)
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = "File Template",
        finder = finders.new_table {
            results = get_templates_from_folder(opts.template_folder)
        },

        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function ()
                local selected_entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if callback then
                    -- Call the callback with the selected template
                    callback(selected_entry[1])
                end
            end)
            return true
        end,
    }):find()
end

local function create_or_overwrite_file(file_name, template_name)

    if template_name == "ignore" then
        return
    end

    local template_path = vim.fn.expand(M.opts.template_folder .. "/" .. template_name)
    local file_path = vim.fn.expand(file_name)

    if vim.fn.filereadable(template_path) == 1 then
        local template_content = vim.fn.readfile(template_path)
        vim.fn.writefile(template_content, file_path) -- Overwrites if the file exists
        vim.cmd('edit ' .. file_path)
        print("File created/overwritten with template:", template_name)
    else
        print('Template file not found')
    end
end

-- Define the template selection function
local function select_template_and_create_file(file_name)
    select_template({}, function(selected_template)
        create_or_overwrite_file(file_name, selected_template)
    end)
end

-- Define the custom command
vim.api.nvim_create_user_command('CreateFileWithTemplate', function(opts)
    local file_name = opts.args
    if file_name == "" then
        print("Please provide a file name.")
    else
        select_template_and_create_file(file_name)
    end
end, { nargs = 1, desc = "Create or overwrite a file with a selected template" })

return M
