# How to Release?
- Step1. Bump version
```
bundle exec rake bump
```

- Step2. Bump the version of plugins to the latest automatically. Otherwise, you can modify the `mbox-package.yml`
```
bundle exec rake bump_plugin
```

- Step3. Build and Archive
```
bundle exec rake package
```

- Step4. Upload package
```
bundle exec rake release [github_token] [package_file]
```
package_file may locate at ../temp/release 