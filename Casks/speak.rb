cask "speak" do
  version "1.0.2"
  # Pinned, not :no_check. The download URL carries the version, so the file it
  # points at is immutable and its hash is knowable. :no_check would tell
  # Homebrew to install whatever bytes arrive at that URL. Rewritten on every
  # release by the homebrew-tap workflow in mugoosse/speak, which reads the
  # hash from the published DMG.
  sha256 "b53f3eef5d627b5a7f87d842c9392c8000170f1d7cd8372beafc7d538d587c20"

  url "https://github.com/mugoosse/speak/releases/download/v#{version}/Speak-#{version}.dmg"
  name "Speak"
  desc "Push-to-talk dictation that runs entirely on your Mac"
  homepage "https://github.com/mugoosse/speak"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  # Speak updates itself through Sparkle, and Homebrew has to be told, or the
  # two fight over who owns the version: Sparkle replaces the app in place,
  # Homebrew's own recorded version goes stale, and `brew upgrade` reinstalls
  # an app that is already current.
  #
  # Note this does not mean "never upgrade". Homebrew still upgrades
  # auto_updates casks, but it compares the version inside the installed app
  # bundle rather than only its own metadata, so a copy Sparkle already brought
  # up to date is correctly left alone.
  auto_updates true

  app "Speak.app"

  uninstall quit: "com.mgo.speak"

  # The model cache is deliberately left alone by uninstall: it is ~2.4 GB and
  # shared with anything else using mlx-audio, so removing it is opt-in.
  zap trash: [
    "~/Library/Application Support/speak",
    "~/Library/Caches/com.mgo.speak",
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
