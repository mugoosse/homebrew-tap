# mugoosse/homebrew-tap

Homebrew formulae and casks for my projects.

```sh
brew tap mugoosse/tap
brew trust mugoosse/tap
brew install --cask listen
brew install --cask speak
```

`brew trust` is Homebrew 6.0 and later refusing to load a cask from a tap that
is not one of its own until you say so. Trusting the tap covers everything in
it; `brew trust --cask mugoosse/tap/listen` trusts one cask and nothing else.
Without either, install stops and tells you the same thing.

## Casks

| Cask | Description |
|---|---|
| [listen](https://github.com/mugoosse/listen) | Meeting recorder, transcriber and speaker labeller that runs entirely on your Mac |
| [speak](https://github.com/mugoosse/speak) | Push-to-talk dictation that runs entirely on your Mac |
