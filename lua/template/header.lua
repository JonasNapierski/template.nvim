local util = require "template.util"

local M = {}
function M.header_parse(template_content)
    if not template_content then
        return {}
    end

    local header_lines = util.split(template_content, '\n')

    if not header_lines then
        return {}
    end

    local header = {}
    local starting_header = false
    local current_header = ''
    for _, value in pairs(header_lines) do

        if starting_header then
            if (string.find(value, "^%s*%-%s.*")) then
                if current_header == '' then
                    current_header = 'global'

                    if header[current_header] == nil then
                        header[current_header] = {}
                    end
                end

                local has_tag, _, tag_name = string.find(value, "^%s*%-%s(.*)")

                if has_tag then
                    table.insert(header[current_header], tag_name)
                end
            else
                if current_header == '' then
                    local has_field_name, _, header_field_name = string.find(value, ".*:")

                    if has_field_name then
                        current_header = 'global'
                    else
                        current_header =header_field_name
                    end

                    if header[current_header] == nil then
                        header[current_header] = {}
                    end
                end
            end

        end

        if (string.find(value, "^%-%-%-+")) then
            starting_header = not starting_header

            if not starting_header then
                break
                -- after the second time the atleast three dashes are detected the header will be stopped parsing.
            end
        end
    end

    return header
end


return M
