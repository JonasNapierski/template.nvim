local header = require("template.header")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local template = {}

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

function template.select_template(opts, callback)
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

function template.read_template(template_name)
    local template_path = vim.fn.expand(M.opts.template_folder .. "/" .. template_name)

    if vim.fn.filereadable(template_path) == 1 then
        return vim.fn.readfile(template_path)
    else
        return nil
    end
end

local function create_or_overwrite_file(file_name, template_name)

    if template_name == "ignore" then
        return
    end

    local template_content = template.read_template(read_template)
    local file_path = vim.fn.expand(file_name)

    if template_content then
        vim.fn.writefile(template_content, file_path) -- Overwrites if the file exists
        vim.cmd('edit ' .. file_path)
        print("File created/overwritten with template:", template_name)
    else
        print('Template file not found')
    end
end

-- Define the template selection function
--- create a file with a selected template. If template with the name ignore is selected no template will be used during creation of the file.
---@param file_name any
function template.select_template_and_create_file(file_name, template_folder)
    template.select_template({}, function(selected_template)
        create_or_overwrite_file(file_name, selected_template)
    end)
end

return template
