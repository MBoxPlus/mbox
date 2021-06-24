# Release

## Release MBox

### Step1. Bump Plugin Version to Latest
You can also change plugins' version in the file `mbox-package.yml` manually.
```
bundle exec rake 'bump_plugin'
```

### Step2. Bump Version
```
bundle exec rake 'bump[x.y.z]'
```

### Step3. Archive
```
bundle exec rake 'package[GITHUB_TOKEN]'
```

### Step4. Release
```
bundle exec rake 'release[GITHUB_TOKEN]'
```

## Release Plugins
```
bundle exec rake build_plugin

bundle exec rake 'release_plugin[GITHUB_TOKEN]'
```
