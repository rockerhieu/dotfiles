-- Pull in the wezterm API
local os              = require 'os'
local wezterm         = require 'wezterm'
local session_manager = require 'wezterm-session-manager/session-manager'
local act             = wezterm.action
local mux             = wezterm.mux

-- --------------------------------------------------------------------
-- FUNCTIONS AND EVENT BINDINGS
-- --------------------------------------------------------------------

-- Session Manager event bindings
-- See https://github.com/danielcopper/wezterm-session-manager
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- --------------------------------------------------------------------
-- CONFIGURATION
-- --------------------------------------------------------------------

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.color_scheme = 'Solarized (dark) (terminal.sexy)'
config.enable_scroll_bar = true
config.enable_wayland = true
-- config.font = wezterm.font('Hack')
config.font = wezterm.font('Monaspace Neon')
config.font_size = 16.0
config.hide_tab_bar_if_only_one_tab = true
-- The leader is similar to how tmux defines a set of keys to hit in order to
-- invoke tmux bindings. Binding to ctrl-a here to mimic tmux
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.mouse_bindings = {
    -- Open URLs with Ctrl+Click
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    }
}
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.window_decorations = 'RESIZE'
config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 10,
}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30

wezterm.on('update-status', function(window)
    -- Grab the utf8 character for the "powerline" left facing
    -- solid arrow.
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  
    -- Grab the current window's configuration, and from it the
    -- palette (this is the combination of your chosen colour scheme
    -- including any overrides).
    local color_scheme = window:effective_config().resolved_palette
    local bg = color_scheme.background
    local fg = color_scheme.foreground
  
    window:set_right_status(wezterm.format({
      -- First, we draw the arrow...
      { Background = { Color = 'none' } },
      { Foreground = { Color = bg } },
      { Text = SOLID_LEFT_ARROW },
      -- Then we draw our text
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = ' ' .. wezterm.hostname() .. ' ' },
    }))
  end)
  

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 32
config.colors = {
    tab_bar = {
        active_tab = {
            fg_color = '#073642',
            bg_color = '#2aa198',
        }
    }
}

-- Setup muxing by default
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- Include homebrew bin into $PATH
config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

-- Custom key bindings
config.keys = {
    -- -- Disable Alt-Enter combination (already used in tmux to split pane)
    -- {
    --     key = 'Enter',
    --     mods = 'ALT',
    --     action = act.DisableDefaultAssignment,
    -- },

    -- Words navigation on MacOS
    -- Sends ESC + b and ESC + f sequence, which is used
    -- for telling your shell to jump back/forward.
    {
        -- When the left arrow is pressed
        key = 'LeftArrow',
        -- With the "Option" key modifier held down
        mods = 'OPT',
        -- Perform this action, in this case - sending ESC + B
        -- to the terminal
        action = wezterm.action.SendString '\x1bb',
    },
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = wezterm.action.SendString '\x1bf',
    },

    -- Open Settings
    {
        key = ',',
        mods = 'SUPER',
        action = wezterm.action.SpawnCommandInNewTab {
          cwd = wezterm.home_dir,
          args = { 'code', wezterm.config_file },
        },
    },

    -- Copy mode
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode,
    },

    -- ----------------------------------------------------------------
    -- TABS
    --
    -- Where possible, I'm using the same combinations as I would in tmux
    -- ----------------------------------------------------------------

    -- Show tab navigator; similar to listing panes in tmux
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ShowTabNavigator,
    },
    -- Create a tab (alternative to Ctrl-Shift-Tab)
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    -- Rename current tab; analagous to command in tmux
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end
            ),
        },
    },
    -- Move to next/previous TAB
    {
        key = 'n',
        mods = 'LEADER',
        action = act.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivateTabRelative(-1),
    },
    -- Close tab
    {
        key = '&',
        mods = 'LEADER|SHIFT',
        action = act.CloseCurrentTab{ confirm = true },
    },

    -- ----------------------------------------------------------------
    -- PANES
    --
    -- These are great and get me most of the way to replacing tmux
    -- entirely, particularly as you can use "wezterm ssh" to ssh to another
    -- server, and still retain Wezterm as your terminal there.
    -- ----------------------------------------------------------------

    -- -- Vertical split
    {
        -- _
        key = '_',
        mods = 'LEADER|SHIFT',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 },
        },
    },
    -- Horizontal split
    {
        -- -
        key = '-',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 50 },
        },
    },
    -- CTRL + (h,j,k,l) to move between panes
    {
        key = 'h',
        mods = 'CTRL',
        action = act({ EmitEvent = "move-left" }),
    },
    {
        key = 'j',
        mods = 'CTRL',
        action = act({ EmitEvent = "move-down" }),
    },
    {
        key = 'k',
        mods = 'CTRL',
        action = act({ EmitEvent = "move-up" }),
    },
    {
        key = 'l',
        mods = 'CTRL',
        action = act({ EmitEvent = "move-right" }),
    },
    -- ALT + (h,j,k,l) to resize panes
    {
        key = 'h',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-left" }),
    },
    {
        key = 'j',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-down" }),
    },
    {
        key = 'k',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-up" }),
    },
    {
        key = 'l',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-right" }),
    },
    -- Close/kill active pane
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = true },
    },
    -- Swap active pane with another one
    {
        key = '{',
        mods = 'LEADER|SHIFT',
        action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },
    },
    -- Zoom current pane (toggle)
    {
        key = 'z',
        mods = 'LEADER',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'f',
        mods = 'ALT',
        action = act.TogglePaneZoomState,
    },
    -- Move to next/previous pane
    {
        key = ';',
        mods = 'LEADER',
        action = act.ActivatePaneDirection('Prev'),
    },
    {
        key = 'o',
        mods = 'LEADER',
        action = act.ActivatePaneDirection('Next'),
    },

    -- ----------------------------------------------------------------
    -- Workspaces
    --
    -- These are roughly equivalent to tmux sessions.
    -- ----------------------------------------------------------------

    -- Attach to muxer
    {
        key = 'a',
        mods = 'LEADER',
        action = act.AttachDomain 'unix',
    },

    -- Detach from muxer
    {
        key = 'd',
        mods = 'LEADER',
        action = act.DetachDomain { DomainName = 'unix' },
    },

    -- Show list of workspaces
    {
        key = 's',
        mods = 'LEADER',
        action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
    },
    -- Rename current session; analagous to command in tmux
    {
        key = '$',
        mods = 'LEADER|SHIFT',
        action = act.PromptInputLine {
            description = 'Enter new name for session',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        mux.rename_workspace(
                            window:mux_window():get_workspace(),
                            line
                        )
                    end
                end
            ),
        },
    },

    -- Session manager bindings
    {
        key = 's',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "save_session" }),
    },
    {
        key = 'L',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "load_session" }),
    },
    {
        key = 'R',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "restore_session" }),
    },
}

-- and finally, return the configuration to wezterm
return config