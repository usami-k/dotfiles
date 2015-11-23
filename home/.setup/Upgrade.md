## homebrew

```
brew upgrade --all && brew cleanup
```

## gem (bundler)

```
bundle update && bundle clean --force
```

## npm

```
npm -g upgrade
```

## pip

```
pip3 install -U $(pip3 list --outdated | cut -d' ' -f 1)
```

