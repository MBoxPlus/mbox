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
mbox add https://github.com/MBoxPlus/mbox-core.git main
mbox add https://github.com/MBoxPlus/mbox-workspace.git main
# You can add one or more MBox plugin source-code repositories here.
... 

# Run pod install
mbox pod install
```

Open the Xcode workspace `DevMBox.xcworkspace` and `Build` it.

### 3. Run

There are two kinds of ways to debug MBox CLI.

#### Terminal

```
# Set configuration for the root path of the workspace
mbox config core.dev-root /[PATH]/DevMBox -g
```

Now you can use `mdev` to replace `mbox` to run locally.

#### Xcode

Open `Edit Scheme...`>`Run`>`Arguments` and set MBox CLI arguments. Please make sure the argument `--dev-root` is set. 

> `--root` The root path of the workspace for testing
> 
> `--dev-root` The root path of the MBox development workspace.