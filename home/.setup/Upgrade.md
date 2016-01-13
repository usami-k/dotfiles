## homebrew

```
brew upgrade --all && brew cleanup
```

## homebrew cask

```
brew cask install $(brew cask list)
```

## gem (bundler)

```
bundle update && bundle clean --force
```

## pip

```
pip3 install -U $(pip3 list --outdated | cut -d' ' -f 1)
```

