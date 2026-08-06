cask "listen" do
  version "0.3.0"
  # Pinned, not :no_check. The download URL carries the version, so the file it
  # points at is immutable and its hash is knowable. :no_check would tell
  # Homebrew to install whatever bytes arrive at that URL.
  #
  # Note this pins Listen-x.y.z.dmg and not the Listen.dmg published alongside
  # it. They are the same bytes, but only the versioned URL is immutable, and
  # pinning a hash to a moving URL is worse than not pinning one at all.
  #
  # Bumped from the hash release.sh writes into dist/SHA256SUMS.txt, normally
  # by homebrew-tap.yml in mugoosse/listen, which rewrites these two lines and
  # opens a pull request against this file.
  #
  # It edits with sed rather than regenerating the cask, and that is the part
  # worth keeping: the caveats and the zap stanza below are hand-written, and
  # nothing in a release implies either of them, so a generator would quietly
  # flatten both. Bumping by hand is the fallback when a run fails, and then
  # these are still the only two lines that change.
  sha256 "3517e95764534991dbef711e3fbfb594eb3c18dfbabbf46431b16bf788ba5530"

  url "https://github.com/mugoosse/listen/releases/download/v#{version}/Listen-#{version}.dmg"
  name "Listen"
  # No "on your Mac" here, however well it reads: brew style rejects a
  # description naming the platform. The caveats carry what it costs.
  desc "Local meeting recorder, transcriber and speaker labeller"
  homepage "https://github.com/mugoosse/listen"

  # Listen updates itself through Sparkle, and Homebrew has to be told, or the
  # two fight over who owns the version: Sparkle replaces the app in place,
  # Homebrew's own recorded version goes stale, and `brew upgrade` reinstalls
  # an app that is already current.
  #
  # Note this does not mean "never upgrade". Homebrew still upgrades
  # auto_updates casks, but it compares the version inside the installed app
  # bundle rather than only its own metadata, so a copy Sparkle already brought
  # up to date is correctly left alone.
  auto_updates true
  # LSMinimumSystemVersion in the bundle is 14.0. Capturing the other side of a
  # call needs 14.2, and on 14.0 or 14.1 Listen records the microphone only,
  # which is a reduced app rather than a broken one. So the floor stays at what
  # the bundle says and the caveat carries the rest.
  #
  # auto_updates before depends_on, and no blank line between them: they are
  # one stanza group and brew style enforces both. speak.rb predates that and
  # reports the same four offences.
  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Listen.app"

  uninstall quit: "com.mgo.listen"

  # ~/Library/Application Support/Listen is deliberately absent, and it is the
  # one thing in this file worth arguing about. It holds the recordings: one
  # folder per meeting, with the audio, the transcript and the voiceprints.
  # `--zap` is a flag people pass without reading it, and the cost either way
  # is not symmetric. Leaving preferences behind costs nothing, because they
  # regenerate. Deleting an hour of somebody's meetings deletes the only copy.
  #
  # The consequence is that --zap does not remove everything, which is a
  # Homebrew convention this breaks on purpose. The caveats say where the
  # recordings are and how to remove them, so it is a choice somebody makes
  # rather than one made for them.
  #
  # The model cache is left alone for the same reason it is in speak: it is
  # about 2.5 GB under ~/.cache/huggingface, shared with anything else using
  # mlx-audio, and removing it would cost Speak its model too.
  zap trash: [
    "~/Library/Caches/com.mgo.listen",
    "~/Library/Preferences/com.mgo.listen.plist",
  ]

  caveats <<~EOS
    Listen needs two permissions on first launch:

      Microphone       so it can hear your side
      Audio Recording  so it can hear everyone else

    It asks for audio recording and not screen recording. Calendar access is
    optional and buys one thing, naming a recording after the meeting already
    in your diary.

    Capturing the other side of a call needs macOS 14.2. On 14.0 and 14.1
    Listen records your microphone only.

    The speech model downloads about 2.5 GB the first time you transcribe
    something, not during install. It is shared with Speak.

    Meeting detection is on by default: Listen starts recording when it sees
    one app using the microphone and the speakers at once, then asks on screen
    whether you are really in a meeting. Answering no deletes the audio.

    Your recordings live in ~/Library/Application Support/Listen and are left
    behind by both uninstall and `brew uninstall --zap`, because that is the
    only copy of them. Remove them by hand when you want them gone:

      rm -rf ~/Library/Application\\ Support/Listen

    If you installed the `listen` command from the Developers pane, it is a
    symlink into the app and uninstalling leaves it dangling:

      rm -f /usr/local/bin/listen ~/.local/bin/listen
  EOS
end
