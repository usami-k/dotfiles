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
pip install -U $(pip list --outdated | cut -d' ' -f 1)
```

