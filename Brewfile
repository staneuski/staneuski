# https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f

tap "homebrew/bundle"

def brew_if(condition, *packages)
  packages.each { |pkg| brew pkg if condition }
end

brew_if OS.linux?,
  "bat",
  "entr",
  "eza",
  "fzf",
  "gcc",
  "git-lfs",
  "jq",
  "lazygit",
  "lf",
  "numpy",
  "openssl@3",
  "perl",
  "pigz",
  "python@3.13",
  "rclone",
  "ripgrep",
  "starship",
  "virtualenv",
  "yq",
  "zoxide"
