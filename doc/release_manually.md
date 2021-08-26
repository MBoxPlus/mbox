# Release Manually

This doc is only for internal member of MBox Team.

## Release Plugins

### Step0. Authentication
Create a Github PAT(Personal Access Token) file.
```
echo GITHUB_ACCESS_TOKEN >> github.token
```
> If you don't have Github PAT, you can generate it on [GitHub](https://github.com/settings/tokens).


### Step1. Build
```
bundle exec rake build_plugin
```

### Step2. Release
```
bundle exec rake release_plugin
```
> Use `FORCE_RELEASE=1` to override the existing version.
