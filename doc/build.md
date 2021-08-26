 # Build
 
First off, thank you for reading this doc. We are really excited to collaborate with you! 🎉

The following instructions will tell you how to build&run this project locally.

### 1. Prepare

Make sure that MBox have already been installed. [MBox Installation](../README.md#installation)

It's so exciting that you can develop MBox with itself!

### 2. Build

```
# Make a work directory
mkdir DevMBox && cd DevMBox

# Init a workspace
mbox init plugin

# Add configuration to allow multiple containers
mbox config container.allow_multiple_containers Bundler CocoaPods

# Add source code repository
mbox add https://github.com/MBoxPlus/mbox-workspace.git main
mbox add https://github.com/MBoxPlus/mbox-container.git main

# Run pod install
mbox pod install
```

You can open Xcode Workspace `DevMBox.xcworkspace` and `Build` now.

### 3. Run

```
# Add configuration root path of the workspace
mbox config core.dev-root /[PATH]/DevMBox -g
```

Now you can use `mdev` to replace `mbox` to run locally.