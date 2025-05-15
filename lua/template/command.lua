local template = require "template.template"
local header = require("template.header")
local command = {}

function command.setup(opts)
    template.template_folder = opts.template_folder

    vim.api.nvim_create_user_command('TemplateConfigTemplateFolder', function(cmd_opts)
        local file_name = cmd_opts.args
        if not file_name then
            print("Please provide a file name.")
        else
            print(template.get_template_folder())
        end
    end, { nargs = 0 })

    vim.api.nvim_create_user_command('TemplateConfigTemplates', function(cmd_opts)
        local templates = template.get_templates()

        for index, value in pairs(templates) do
            print(index, ": ", value)
        end
    end, { nargs = 0 } )

    vim.api.nvim_create_user_command('CreateFileWithTemplate', function(cmd_opts)
        local file_name = cmd_opts.args
        if not file_name then
            print("Please provide a file name.")
        else

            template.select_template_and_create_file(file_name, opts.template_folder)
        end
    end, { nargs = 1, desc = "Create or overwrite a file with a selected template" })

    vim.api.nvim_create_user_command('TemplateMetaTags', function(cmd_opts)
        local template_name = cmd_opts.args

        if not template_name then
            print("Please provide a template name.")
        else
            local content = template.read_template(template_name)
            local header_parser = header.header_parse(content)
            for index, value in pairs(header_parser.tags) do
                print (index,": ",value)
            end
        end

    end, {nargs = 1})
end


return command
