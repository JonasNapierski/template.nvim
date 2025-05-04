local M = {}

function M.setup(opts)
    opts = opts or {}

    if opts.default then
        error("'default' is not a valid for setup. See 'defaults'")
    end

end

function M.helloWorld()
    print("Hello World")
end

return M
