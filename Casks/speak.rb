cask "speak" do
  version "1.0.0"
  sha256 :no_check

  url "https://github.com/mugoosse/speak/releases/download/v#{version}/Speak-#{version}.dmg"
  name "Speak"
  desc "Push-to-talk dictation that runs entirely on your Mac"
  homepage "https://github.com/mugoosse/speak"

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Speak.app"

  uninstall quit: "com.mgo.speak"

  # The model cache is deliberately left alone by uninstall: it is ~2.4 GB and
  # shared with anything else using mlx-audio, so removing it is opt-in.
  zap trash: [
    "~/Library/Application Support/speak",
    "~/Library/Preferences/com.mgo.speak.plist",
  ]

  caveats <<~EOS
    Speak needs two permissions on first launch:

      Microphone     so it can hear you
      Accessibility  so the keyboard shortcut works in any app

    Grant them in System Settings > Privacy & Security, then relaunch.

    The Parakeet engine downloads about 2.4 GB the first time it is used.
    Choose Apple Intelligence during setup to skip that.
  EOS
end
