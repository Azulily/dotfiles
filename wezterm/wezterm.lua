-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action -- 【修正点1】act 変数をここで定義する

-- This will hold the configuration.
local config = wezterm.config_builder()

-- ステータスバーに現在のワークスペース名を表示
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

-- ワークスペースの初期レイアウトを自動生成するイベントハンドラ
wezterm.on('setup-workspace-layout', function(window, pane)
  local workspace_name = window:active_workspace()
  local panes = window:active_tab():panes_with_info()
  
wezterm.log_error("setup-workspace-layout triggered for workspace: '" .. workspace_name .. "'")


  if #panes == 1 then
    if workspace_name == 'ws1' then
      -- 「ws1」用のレイアウト (例: 3ペイン)
      wezterm.log_error("ws1 layout applied.") -- 確認用ログ

      local pane_1 = pane:split{direction="Left", size=0.34}
      
    elseif workspace_name == 'ws2' then
      wezterm.log_error("ws2 layout applied.") -- 確認用ログ

      -- 「ws2」用のレイアウト (例: 2ペイン)
      pane:split{direction="Bottom", size=0.5}
    end
  end
end)

-- This is where you actually apply your config choices.
config.initial_cols = 120
config.initial_rows = 30
config.line_height = 1.0
config.font = wezterm.font('CaskaydiaCove Nerd Font', { weight = 'Regular' })
config.font_size = 17

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'm',
    mods = 'LEADER',
    -- 【修正点2】古いAPIから、wezterm内蔵のワークスペースランチャーを使うように変更
    action = act.ShowLauncherArgs {
      flags = "WORKSPACES"
    },
  },
  {
    key = '[',
    mods = 'CTRL',
    action = act.PaneSelect
  },
}

-- 【修正点3】ワークスペース切り替えのキー設定を統一
-- Cmd + 数字キー または Ctrl + 数字キーで、レイアウト自動生成付きの切り替えを実行
local mods = { 'CMD', 'CTRL' }
for _, mod in ipairs(mods) do
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = mod,
      action = act.Multiple {
        act.SwitchToWorkspace { name = 'ws' .. i },
        act.EmitEvent('setup-workspace-layout'),
      }
    })
  end
end

config.audible_bell = "Disabled"
config.color_scheme = 'Tomorrow Night'
config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.show_new_tab_button_in_tab_bar = false
config.debug_key_events = true

return config
