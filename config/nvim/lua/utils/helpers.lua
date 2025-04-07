local M = {}

-- Safely require a module
M.safe_require = function(module)
    local ok, lib = pcall(require, module)
    if not ok then
        vim.notify("Plugin '" .. module .. "' not found!", vim.log.levels.ERROR)
        return nil
    end
    return lib
end

-- Function to check if a command exists
M.command_exists = function(cmd)
    return vim.fn.executable(cmd) == 1
end

return M
