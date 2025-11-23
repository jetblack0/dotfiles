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

M.get_keys = function(tbl)
  local keys_tbl = {}
  for key, _ in pairs(tbl) do
    table.insert(keys_tbl, key)
  end
  return keys_tbl
end

M.extract = function(tbl, key)
  local out = {}
  for _, v in pairs(tbl) do
    if v[key] then
      table.insert(out, v[key])
    end
  end
  return out
end

return M
