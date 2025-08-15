cask "paraview@5.13" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "5.13.3,MPI-OSX11.0-Python3.10"
    sha256 "d37e9d7e83733b8881d63a260b2252800afff167cd37f7297c3f0c06e06b94cb"
  end
  on_intel do
    version "5.13.3,MPI-OSX10.15-Python3.10"
    sha256 "edb08077d8032a106cc32ad7ef6e1fb3440a9be93c39c212975b3d44fae1bd72"
  end

  url "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v#{version.csv.first.major_minor}&type=binary&os=macOS&downloadFile=ParaView-#{version.csv.first}#{"-#{version.csv.second}" if version.csv.second}-#{arch}.dmg",
      user_agent: :fake
  name "ParaView"
  desc "Data analysis and visualization application"
  homepage "https://www.paraview.org/"

  livecheck do
    url "https://www.paraview.org/files/listing.txt"
    regex(%r{/v?(?:\d+(?:\.\d+)+)/ParaView[._-]v?(\d+(?:[.-]\d+)+)(?:[._-](.*?))?[._-](?:#{arch}|universal)\.dmg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        match[1] ? "#{match[0]},#{match[1]}" : match[0]
      end
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "ParaView-#{version.csv.first}.app"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/MacOS/paraview"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/pvbatch"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/pvdataserver"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/pvpython"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/pvrenderserver"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/pvserver"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/MacOS/hydra_pmi_proxy"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/MacOS/mpiexec"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/ospray_mpi_worker"
  binary "#{appdir}/ParaView-#{version.csv.first}.app/Contents/bin/vrpn_server"


  zap trash: [
    "~/.config/ParaView",
    "~/Library/Saved Application State/org.paraview.ParaView.savedState",
  ]
end
