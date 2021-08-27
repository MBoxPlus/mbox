# iOS 项目接入与使用

## 1. 创建 Workspace

首先创建一个 Workspace

```shell
mkdir HelloMBox && cd HelloMBox # Create a directory

mbox init ios # Initialize a workspace
```

## 2. 配置 Container

> `Container` 是一个存储项目工程和依赖描述文件的仓库

在项目仓库的根目录创建 `.mboxconfig` 文件。

```JSON
{
    "podfile": "Relative path to Podfile",
    "xcodeproj": "Relative path to xcodeproj", // optional
    "podlock": "Relative path to Podfile.lock"  // optional
}
```

提交并推送你的修改到远端。

如果你没有自己的项目工程，这里有一个已经创建好的[例子](https://github.com/MBoxPlus/MBoxReposDemo/blob/main/.mboxconfig)

> 我们强烈建议你使用 `Gemfile` 来管理 `CocoaPods` 的版本。

## 3. 添加 Container

运行这个命令将你的 app 仓库添加到这个 workspace 中。

```shell
mbox add [GIT_URL] [BRANCH]
# For Example: mbox add https://github.com/MBoxPlus/MBoxReposDemo.git main
```

## 4. Pod Install

在 `pod install` 命令前插入 `mbox`.

```shell
mbox pod install
```

稍等片刻（这取决于你项目的依赖数量）

## 5. 打开 Xcode

使用命令 `mbox go` 来打开 Xcode，接着就可以编译并运行你的项目了。

```shell
mbox go
```

## 6. 创建 Feature

```shell
mbox feature start [feature_name]
# For Example: mbox feature start hello_mbox
```

## 7. 依赖的子仓

在这之前需要再执行一次 `mbox pod install`，`feature` 的工作空间是互相隔离的。

```shell
mbox pod install
```

我们常常需要同时开发项目下的一些依赖仓库。

```shell
mbox add [DEPENDENT_GIT_URL] [TARGET_BRANCH] --checkout-from-commit
# For Example: mbox add https://github.com/SnapKit/SnapKit.git develop --checkout-from-commit
```

> `--checkout-from-commit` 根据当前依赖关系找到对应版本切出分支。

请确认 `.podspec` 在依赖仓库的根目录，如果不在，你需要添加一个 `.mboxconfig` 文件来指明文件路径。

```JSON
{
    "podspecs": ["Relative path to podspec", ...]
}
```

再次执行 `mbox pod install`， 你将会发现该依赖库的源码出现在了 `Development Pods` 组下。

---

## 资源

[快速开始 Demo](quick_start_demo_ios.md)

[CLI 文档](https://github.com/MBoxPlus/mbox/wiki/CLI-documentation)

[MBoxCocoaPods 文档](https://github.com/MBoxPlus/mbox-cocoapods)