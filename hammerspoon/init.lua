--[[
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
for spoon in <spoons>; do
  curl -LO $spoon --output-dir ~/.config/hammerspoon/Spoons/
done
]]

hs = hs -- prevents warnings
primaryShortcut = {"ctrl", "alt", "shift"}

hs.hotkey.bind(primaryShortcut, "T", function()
  hs.application.launchOrFocus("Kitty")
end)

hs.hotkey.bind(primaryShortcut, "D", function()
  local _, isLightMode = hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set lightModeState to dark mode
        set dark mode to not dark mode
      end tell
    end tell
    return lightModeState
  ]])

  -- kitty
  hs.task.new("/run/current-system/sw/bin/kitty", nil, {
    "+kitten",
    "themes",
    "--reload-in=all",
    isLightMode and "Goph Mar" or "Dracula",
  }):start()
  hs.timer.doAfter(0.25, function()
    hs.task.new("/bin/sh", nil, {"-c", "pkill -30 -a kitty"}):start()
  end)

  -- helix
  hs.task.new("/bin/sh", nil, {"-c", (
      isLightMode
      and "sed -i'.prev' 's/theme = \"term16_dark\"/theme = \"term16_light\"/g' "
      or "sed -i'.prev' 's/theme = \"term16_light\"/theme = \"term16_dark\"/g' "
    ) .. os.getenv("HOME") .. "/.config/helix/config.toml",
  }):start()
end)

hs.hotkey.bind(primaryShortcut, "R", function()
  hs.reload()
end)
hs.alert.show("🔨")
