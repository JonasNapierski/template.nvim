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
    local line_num = table.getn(header_lines)

    if line_num < 3 then
        return {}
    end

    local starting_header = false
    local current_header = ''
    for _, value in pairs(header_lines) do
        if (string.find(value, "^%-%-%-+")) then
            starting_header = not starting_header

            if not starting_header then
                -- break
            end
        end

        if starting_header then
            print("haeder started")
            if (string.find(value, "%s*&-%s.*")) then
               print("Field")
                -- TODO: add to field if field is set
                if current_header == '' then
                    -- TODO: filter out none field objects.

                end
            else
                -- TODO: parse field name and add it to table
            end

        end
    end

    return header_lines
end


local t = header_parse "---\ntags\n- hello\n---"
-- local t = header_parse "---\ntags\n- hello\n---"
print(table.getn(t))
