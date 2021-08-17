# Release Manually

## Release MBox

Create a Github PAT(Personal Access Token) file.
```
echo GITHUB_ACCESS_TOKEN >> github.token
```
> If you don't have Github PAT, you can generate it on [GitHub](https://github.com/settings/tokens).

### Step1. Bump Plugin Version to Latest
You can also change plugins' version in the file `mbox-package.yml` manually.
```
bundle exec rake bump_plugin
```

### Step2. Bump Version
```
bundle exec rake 'bump[x.y.z]'
```

### Step3. Archive
```
bundle exec rake package
```

### Step4. Release
```
bundle exec rake release
```

## Release Plugins

### Step1. Build
```
bundle exec rake build_plugin
```

### Step2. Release
```
bundle exec rake release_plugin
```
> Use `FORCE_RELEASE=1` to override the existing version.
