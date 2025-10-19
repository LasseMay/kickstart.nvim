-- lua/pdflink_sioyek.lua
local M = {}

-- percent decoder
local function url_decode(s)
  if not s or s == '' then
    return s
  end
  s = s:gsub('+', ' ')
  s = s:gsub('%%(%x%x)', function(h)
    return string.char(tonumber(h, 16))
  end)
  return s
end

local function strip_quotes(s)
  if not s then
    return s
  end
  s = s:gsub('^%s+', ''):gsub('%s+$', '')
  s = s:gsub('^"(.*)"$', '%1')
  s = s:gsub("^'(.*)'$", '%1')
  return s
end

local function parse_query(qs)
  local t = {}
  if not qs or qs == '' then
    return t
  end
  for key, val in qs:gmatch '([^&=]+)=([^&=]+)' do
    t[url_decode(key)] = url_decode(val)
  end
  return t
end

-- expand $VAR and ${VAR} with os.getenv, also expands ~ to $HOME
local function expand_env(path)
  if not path or path == '' then
    return path
  end
  -- tilde first
  if path:sub(1, 1) == '~' then
    local home = os.getenv 'HOME' or ''
    path = home .. path:sub(2)
  end
  -- ${VAR}
  path = path:gsub('%${([%w_]+)}', function(name)
    return os.getenv(name) or '${' .. name .. '}'
  end)
  -- $VAR
  path = path:gsub('%$([%w_]+)', function(name)
    return os.getenv(name) or '$' .. name
  end)
  return path
end

-- find pdflink in markdown [title](pdflink://...), or a bare url near cursor
local function extract_pdflink_from_line(line, col)
  local md = line:match '%b[]%((pdflink://[^)%s]+)%)'
  if md then
    return md
  end

  col = (col or 0) + 1
  local last_start, i = nil, 1
  while true do
    local s = line:find('pdflink://', i, true)
    if not s or s > col then
      break
    end
    last_start = s
    i = s + 1
  end
  if not last_start then
    return nil
  end

  local rest = line:sub(last_start)
  return rest:match '^(pdflink://[^%s%]%)}>,]+)'
end

-- shell quote for display only
local function shell_quote(arg)
  if arg == nil then
    return ''
  end
  if arg:match '^[%w%+/:=._-]+$' then
    return arg
  end
  return string.format("'%s'", arg:gsub("'", "'\\''"))
end

-- prepend instance name if set
local function with_instance(cfg, args)
  if cfg.instance_name and cfg.instance_name ~= '' then
    local full = { '--instance-name', cfg.instance_name }
    for _, a in ipairs(args) do
      table.insert(full, a)
    end
    return full
  end
  return args
end

-- print and optionally run a command, prints to :messages without prompting
local function run_cmd(binary, args, cfg)
  local full = with_instance(cfg, args)
  local parts = { shell_quote(binary) }
  for _, a in ipairs(full) do
    parts[#parts + 1] = shell_quote(a)
  end
  if cfg.echo_commands then
    vim.api.nvim_out_write('[pdflink_sioyek] ' .. table.concat(parts, ' ') .. '\n')
  end
  if cfg.print_only then
    return
  end
  vim.fn.jobstart({ binary, unpack(full) }, { detach = true })
end

local function open_pdflink_with_sioyek(url, cfg)
  local path_part, query = url:match '^pdflink://([^?]+)%??(.*)$'
  if not path_part then
    return false
  end

  -- decode, strip quotes, then expand env variables
  local pdf_path = expand_env(strip_quotes(url_decode(path_part)))

  local params = parse_query(query)
  local page = strip_quotes(params.page or '1')
  local find = params.find and strip_quotes(params.find) or nil

  -- open file and hint page
  local open_args = {}
  for _, a in ipairs(cfg.extra_args or {}) do
    table.insert(open_args, a)
  end
  table.insert(open_args, '--page')
  table.insert(open_args, tostring(page))
  table.insert(open_args, pdf_path)
  run_cmd(cfg.binary, open_args, cfg)

  -- enforce page jump, then search, then advance once
  vim.defer_fn(function()
    run_cmd(cfg.binary, { '--execute-command', 'goto_page_with_page_number', '--execute-command-data', tostring(page) }, cfg)

    if find and find ~= '' then
      vim.defer_fn(function()
        run_cmd(cfg.binary, { '--execute-command', 'search', '--execute-command-data', find }, cfg)

        vim.defer_fn(function()
          run_cmd(cfg.binary, { '--execute-command', 'next_item' }, cfg)
        end, cfg.search_step_delay_ms)
      end, cfg.search_delay_ms)
    end
  end, cfg.open_delay_ms)

  return true
end

local function default_browse(url)
  if url and url ~= '' then
    vim.fn['netrw#BrowseX'](url, 0)
  end
end

local function make_smart_gx(cfg)
  return function()
    local line = vim.api.nvim_get_current_line()
    local pos = vim.api.nvim_win_get_cursor(0)
    local col = pos[2]
    local url = extract_pdflink_from_line(line, col) or vim.fn.expand '<cfile>'

    if type(url) == 'string' and url:match '^pdflink://' then
      if open_pdflink_with_sioyek(url, cfg) then
        return
      end
    end
    default_browse(url)
  end
end

function M.setup(opts)
  local cfg = vim.tbl_deep_extend('force', {
    binary = 'sioyek',
    extra_args = {},
    map_gx = true,
    print_only = false,
    echo_commands = true, -- print commands to :messages without prompts
    open_delay_ms = 700,
    search_delay_ms = 300,
    search_step_delay_ms = 200,
    instance_name = nil,
  }, opts or {})

  if cfg.map_gx then
    vim.keymap.set('n', 'gx', make_smart_gx(cfg), { desc = 'Open URL, handle pdflink with Sioyek' })
  end

  vim.api.nvim_create_user_command('PdflinkOpen', function(cmd)
    local arg = table.concat(cmd.fargs, ' ')
    if arg == '' then
      arg = vim.fn.expand '<cfile>'
    end
    if not arg:match '^pdflink://' then
      vim.api.nvim_out_write '[pdflink_sioyek] PdflinkOpen expects a pdflink URL\n'
      return
    end
    if not open_pdflink_with_sioyek(arg, cfg) then
      vim.api.nvim_out_write '[pdflink_sioyek] Could not open pdflink\n'
    end
  end, { nargs = '?', complete = 'file' })
end

return M
