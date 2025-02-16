--[[
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
for spoon in <spoons>; do
  curl -LO $spoon --output-dir S~/.config/hammerspoon/Spoons/
done
]]

hs = hs -- prevents warnings

hs.hotkey.bind({"ctrl", "alt", "shift"}, "T", function()
  local _, isDarkMode = hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set darkModeState to dark mode
        set dark mode to not dark mode
      end tell
    end tell
    return darkModeState
  ]])

  local theme = isDarkMode and "Dracula" or "Goph Mar"
  hs.task.new(
    "/run/current-system/sw/bin/kitty",
    nil,
    {"+kitten", "themes", "--reload-in=all",theme}
  ):start()
  hs.task.new("/bin/sh", nil, {"-c", "pkill -30 -a kitty"}):start()
end)

hs.hotkey.bind({"ctrl", "alt", "shift"}, "R", function()
  hs.reload()
end)
-- hs.alert.show("🔨")
