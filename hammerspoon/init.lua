--[[
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
for spoon in <spoons>; do
  curl -LO $spoon --output-dir ~/.config/hammerspoon/Spoons/
done
]]

hs = hs -- prevents warnings
local primaryShortcut = { "ctrl", "alt", "shift" }

hs.hotkey.bind(primaryShortcut, "T", function()
  hs.application.launchOrFocus("Kitty")
end)

hs.hotkey.bind(primaryShortcut, "B", function()
  local _, isLightMode = hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set lightModeState to dark mode
        set dark mode to not dark mode
      end tell
    end tell
    return lightModeState
  ]])

  -- helix
  hs.task
    .new("/bin/sh", nil, {
      "-c",
      (
        isLightMode and "sed -i'.prev' 's/theme = \"tokyonight_moon\"/theme = \"tokyonight_day\"/g' "
        or "sed -i'.prev' 's/theme = \"tokyonight_day\"/theme = \"tokyonight_moon\"/g' "
      )
        .. os.getenv("HOME")
        .. "/.config/helix/config.toml",
    })
    :start()
end)

hs.hotkey.bind(primaryShortcut, "R", function()
  hs.reload()
end)
hs.alert.show("🔨")
