i = require('inspect')

local function split(pString, pPattern)
   local Table = {}
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function header_parse(template_content)
    if not template_content then
        return {}
    end

    local header_lines = split(template_content, '\n')

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
                    print(i.inspect(header[current_header]))
                    print(tag_name)
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
        end
    end

    return header
end


local t = header_parse "---\ntags:\n- hello\n---"
--local t = header_parse "---\n- hello\n---"
local i = require('inspect')
-- local t = header_parse "---\ntags:\n- hello\n---"
print(i.inspect(t))
