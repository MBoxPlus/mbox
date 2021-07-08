# Getting Started for iOS

## Configuration Container
> Container is the Git repository for storing all of app project or dependencies files.

Add `.mboxconfig` file to the root directory of your project.

```JSON
{
    "podfile": "Relative path to Podfile",
    "xcodeproj": "Relative path to xcodeproj file"
}
```

Commit and push this change.

## Create Workspace

Run this command to create a MBox workspace.

```shell
mkdir HelloMBox && cd HelloMBox # Create a directory

mbox init ios # Initialize a workspace
```

## Add Container
Run this command to add your App's repository to workspace.

```shell
mbox add [GIT_URL]
```

## Pod Install

Add `mbox` prefix to the `pod install` command.

```shell
mbox pod install
```

Wait for minutes. (How long depends on how many pods)

## Open Xcode

Use `mbox go` to open Xcode Workspace. You can now build and run your App.

```shell
mbox go
```

## Create Feature
```
mbox feature start [feature_name]
# For Example: mbox feature start hello_mbox
```

## Add Another Repo

Usually, we have other repositories to develop at the same time.

```
mbox add [ANOTHER_GIT_URL]
```

Please make sure that the `.podspec` file is under the root repo directory. Otherwise, you need to add `.mboxconfig` file to root directory.

```JSON
{
    "podspecs": ["Relative path to podspec", ...],
}
```

Run `mbox pod install` again. You will find this repo is under the `Development Pods` group in Xcode.
