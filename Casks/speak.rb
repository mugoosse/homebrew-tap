cask "speak" do
  version "1.5.1"
  # Pinned, not :no_check. The download URL carries the version, so the file it
  # points at is immutable and its hash is knowable. :no_check would tell
  # Homebrew to install whatever bytes arrive at that URL.
  #
  # Note this pins Speak-x.y.z.dmg and not the Speak.dmg published alongside
  # it. They are the same bytes, but only the versioned URL is immutable, and
  # pinning a hash to a moving URL is worse than not pinning one at all.
  #
  # Bumped from the hash release.sh writes into dist/SHA256SUMS.txt, normally
  # by homebrew-tap.yml in mugoosse/speak, which rewrites these two lines and
  # opens a pull request against this file.
  #
  # It edits with sed rather than regenerating the cask, and that is the part
  # worth keeping: the caveats and the zap stanza below are hand-written, and
  # nothing in a release implies either of them, so a generator would quietly
  # flatten both. Bumping by hand is the fallback when a run fails, and then
  # these are still the only two lines that change.
  sha256 "ef2f4f57d100f3dd7f93aece9dbde02d69f39d3508d3c47147f07eef7451fc50"

  url "https://github.com/mugoosse/speak/releases/download/v#{version}/Speak-#{version}.dmg"
  name "Speak"
  desc "Push-to-talk dictation that runs entirely on your Mac"
  homepage "https://github.com/mugoosse/speak"

  # Dictation moved into Listen, and Speak 1.6.0 is its last release.
  #
  # `deprecate!` rather than `disable!`, deliberately: a deprecated cask still
  # installs and still upgrades, it only prints the reason, so nobody who
  # already runs Speak is cut off by a decision made in another repository. The
  # date is when the farewell release went out, in the past so it takes effect
  # immediately rather than on some future run nobody is watching.
  #
  # `disable!` is the later step, once the repository is archived and the
  # download links are the only thing left. It refuses to install, which is only
  # honest when there is nothing worth installing.
  deprecate! date:    "2026-08-10",
             because: "dictation is now built into Listen: brew install --cask mugoosse/tap/listen"

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
  depends_on macos: :sonoma
  depends_on arch: :arm64

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
    Speak has moved into Listen, which records and transcribes meetings and
    now does everything Speak does:

      brew install --cask mugoosse/tap/listen

    The speech model carries over on its own. Speak 1.6.0 is the last release.

    Speak needs two permissions on first launch:

      Microphone     so it can hear you
      Accessibility  so the keyboard shortcut works in any app

    Grant them in System Settings > Privacy & Security, then relaunch.

    The Parakeet engine downloads about 2.4 GB the first time it is used.
    Choose Apple Intelligence during setup to skip that.
  EOS
end
