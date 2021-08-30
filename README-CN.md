# MBox - 移动研发工具链

**简体中文** | [English](./README.md)

MBox 是一款运行在 macOS 上，专注于移动端研发的工具链应用。它不仅能帮助开发者管理环境、项目依赖和仓库，还允许开发者通过开发 MBox 插件来定制属于自己的工具链。

## 功能

### 1. 多仓库管理

MBox 新增了 Workspace 概念，将所有仓库统一管理，可以快速添加/移除仓库：

```shell
$ mbox add AFNetworking
Prepare Repository
Setup Remote Repository
Setup Git Reference
Add `AFNetworking` into feature `FreeMode`
Preprocess Origin Repository
Setup Work Repository
Checkout branch `master`
Add repo `AFNetworking` success.
```

### 2. Git 批量管理

在 Workspace 内的所有仓库，都受 MBox 控制，可以快速查询和修改 Git 状态：
```shell
$ mbox status
  MyApp          git@github.com:xx/MyApp.git                   [master]*   ↑0  ↓0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [master]    ↑0  ↓0

$ mbox git pull
[MyApp]
  remote: Enumerating objects: 231, done.
  remote: Counting objects: 100% (231/231), done.
  remote: Compressing objects: 100% (131/131), done.
  remote: Total 477 (delta 163), reused 99 (delta 99), pack-reused 246
  Receiving objects: 100% (477/477), 208.00 KiB | 1.86 MiB/s, done.
  Resolving deltas: 100% (287/287), completed with 42 local objects.
[AFNetworking]
  Already up to date.

$ mbox git commit -m "test"
[MyApp]
  [master ad388a15d] test
  1 file changed, 0 insertions(+), 0 deletions(-)
[AFNetworking]
  On branch master
  nothing to commit, working tree clean

$ mbox git checkout develop
[MyApp]
  Switched to branch 'develop'
[AFNetworking]
  Switched to branch 'develop'

$ mbox status
  MyApp          git@github.com:xx/MyApp.git                   [develop]   ↑0  ↓0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [develop]   ↑0  ↓0
```

### Workspace 级别的 Git Hooks

Git 仓库可以拥有独立的 git hooks，MBox 提供了 Workspace 级别的 Git Hooks 统一管理能力，同一个 Hook 会按照以下顺序轮流执行：
1. 运行插件内置 Git Hooks，影响所有仓库 (`Plugin/Resources/gitHooks`)
2. 运行 Workspace 目录下配置 Hooks，影响所有仓库 (`Workspace/.mbox/git/hooks`)
3. 运行仓库内配置 Hooks 目录，影响单个仓库 (`repo/gitHooks`)
4. 运行仓库原生 Hooks 目录，影响单个仓库 (`repo/.git/hooks`)

如果某个脚本执行失败（返回状态码非0），则终止执行。

**注意：上述功能在 MBox 之外，使用其他 Git 客户端或者命令行，对 Workspace 下所有仓库始终有效**

### Feature 需求模型

GitFlow 等分支模型的简化版本，MBox 保留了 Feature 概念，将它延伸到更多方向，不仅仅能够管理所有仓库的分支，还能保留未提交的改动，甚至不同 Feature 下进行仓库的差异化。

```bash
$ mbox status
[Feature]: FreeMode
  MyApp  git@github.com:xx/MyApp.git  [develop]*   ↑0  ↓0
# ↑ 当前在 FreeMode 下，只有一个仓库 MyApp，该仓库处于 master 分支，且本地有未提交的修改

$ mbox feature start testA
Create a new feature `testA`
Save current git HEAD
Stash previous feature `FreeMode`
Backup support files for feature `FreeMode` (Mode: Keep)
Check repo exists
Update workspace
Checkout feature `testA`
Pick stash from `FreeMode` into new feature `testA`
Show Status

[Feature]: testA
  MyApp  git@github.com:xx/MyApp.git  [feature/testA]   ↑0   ↓0   ->   [develop]   ↳0   ↰0
# ↑ 创建新 Feature `testA` ，Workspace 下的仓库 MyApp 自动创建新分支 `feature/testA`，且本地未提交的修改被保存且被重置。
# ↑ Status 能够显示当前分支 `feature/testA` 与远端 `origin/feature/testA` 的差异，同时也显示与来源分支 `origin/develop` 的差异

$ mbox add AFNetworking
Prepare Repository
Setup Remote Repository
Setup Git Reference
Add `AFNetworking` into feature `testA`
Preprocess Origin Repository
Setup Work Repository
Checkout branch `feature/testA` from `master`
Add repo `AFNetworking` success.
Show Status

[Feature]: testA
  MyApp          git@github.com:xx/MyApp.git                   [feature/testA]    ↑0  ↓0   ->   [develop]   ↳0   ↰0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [feature/testA]]   ↑0  ↓0   ->   [master]    ↳0   ↰0
# ↑ 在 Feature 下添加的仓库会自动创建分支，被统一管理

$ mbox merge
[MyApp]
  Merge branch `origin/develop` into branch `feature/testA`.
  Merge Done!
[AFNetworking]
  Merge branch `origin/master` into branch `feature/testA`.
  There is nothing to merge.
# ↑ 快速合并各自仓库的源分支到当前 Feature 分支

$ mbox feature free
Switch to a exists feature `FreeMode`
Save current git HEAD
Stash previous feature `testA`
Backup support files for feature `testA` (Mode: Clear)
Check repo exists
Update workspace
Checkout feature `FreeMode`
Restore feature `FreeMode`
Restore support files
Show Status
[Feature]: FreeMode
  MyApp  git@github.com:xx/MyApp.git  [develop]*   ↑0  ↓0
# ↑ 回到之前的 FreeMode，会还原仓库列表，分支，以及未提交的修改
```

通过上面的例子，可以看出，Feature 是为了快速在多个需求/任务之间切换，相比手动分支操作，有以下特点：

1. 所有仓库都采用相同的分支名，便于管理和理解，切换 Feature 会自动切换仓库分支
1. 不同 Feature 直接存在 仓库列表 隔离，在 Feature 之间切换能快速还原 仓库列表
1. 切换 Feature 无需提交本地未提交的修改，会自动存入 Stash 中，下次切换回来自动还原
1. `FreeMode` 是特殊的 Feature，不对它的分支名称做强制要求，但是也遵循场景还原策略

### Feature 协作

在团队协作中，往往需要多人同步开发一个需求，仓库列表和分支信息等不易交流。MBox 提供 Feature 快速导出与导入，实现同步协助

```bash
$ mbox status
[Feature]: testA
  MyApp          git@github.com:xx/MyApp.git                   [feature/testA]    ↑0  ↓0   ->   [develop]   ↳0   ↰0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [feature/testA]]   ↑0  ↓0   ->   [master]    ↳0   ↰0

$ mbox feature export
{"name":"testA","repos":[{"git":"git@github.com:xx/MyApp.git","target_branch":"develop","name":"MyApp"},{"name":"AFNetworking","git":"git@github.com:AFNetworking/AFNetworking.git","target_branch":"master"}]}

$ mbox feature import '{"name":"testA","repos":[{"git":"git@github.com:xx/MyApp.git","target_branch":"develop","name":"MyApp"},{"name":"AFNetworking","git":"git@github.com:AFNetworking/AFNetworking.git","target_branch":"master"}]}'
Import Success!
Switch to a exists feature `FreeMode`
Save current git HEAD
Stash previous feature `testA`
Backup support files for feature `testA` (Mode: Clear)
Check repo exists
Update workspace
Checkout feature `FreeMode`
Restore feature `FreeMode`
Restore support files
Show Status
[Feature]: testA
  MyApp          git@github.com:xx/MyApp.git                   [feature/testA]    ↑0  ↓0   ->   [develop]   ↳0   ↰0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [feature/testA]]   ↑0  ↓0   ->   [master]    ↳0   ↰0
```

### 环境自动部署

每个工具、每个项目可能都需要预先安装一些系统工具，例如，项目中用了 `git-lfs`，或者 iOS 项目需要安装 `CocoaPods`。同步所有研发人员安装对应版本的工具是一个复杂的过程。

MBox 在所有命令之前，会提前准备环境，保证环境的统一。MBox 称之为 `Launcher`.

例如，`MBoxCore` 核心库有 `XcodeCLT`、`Homebrew` 等依赖，会在首次运行的时候自动安装。

例如，`MBoxCocoapods` `插件需要依赖` CocoaPods，为了保证 Ruby Gem 的隔离，`MBoxCocoapods` 插件使用了 `Bundler` 作为 Gem 沙盒，因此需要先确保 `Bundler` 正常使用。因此 `MBoxCocoapods` 会在首次激活的时候，自动配置 Bundler，无需用户安装 Ruby，直接使用系统 Ruby 即可，也无需安装 CocoaPods，会自动完成这一系列：

```bash
$ mbox pod install -v
Setup Workspace Environment
Check Bundler Version
  Parse `Gemfile.lock`
  Require bundler 2.2.8
  $ gem list -e bundler

    *** LOCAL GEMS ***
    bundler (2.2.19, 2.2.8, 2.1.4, default: 1.17.2)
Using Bundler v2.2.8
Check Bundler Gems
  $ bundle _2.2.8_ check
    Resolving dependencies...
    Install missing gems with `bundle install`
Setup Gemfile.lock
  No valid Gemfile.lock to copy.
Setup Bundler Gems
  $ bundle _2.2.8_ update --all
    Bundle updated!
$ which bundle
  /usr/bin/bundle
$ bundle _2.2.8_ exec pod install --ansi --verbose
....
```

因此，在 MBox 环境下，会保证环境的一致性，例如 CocoaPods 的版本。

### 统一的依赖管理

MBox 抽象了依赖管理，让所有跨端研发人员有相同的用户体验，通过插件化技术，不断扩充支持的依赖管理工具。

目前支持 `Bundler` 和 `CocoaPods` 两种依赖管理工具，后续还会开放 `Gradle`、`Flutter` 等。

在依赖管理工具的支持下，MBox 能很方便的使用本地仓库作为依赖的一部分，从而实现 Development SDK。

例如以 CocoaPods 为例：

```bash
$ mbox status
[Feature]: testA
  MyApp          git@github.com:xx/MyApp.git                   [feature/testA]    ↑0  ↓0   ->   [develop]   ↳0   ↰0
  AFNetworking   git@github.com:AFNetworking/AFNetworking.git  [feature/testA]]   ↑0  ↓0   ->   [master]    ↳0   ↰0

$ mbox pod install
# 将直接使用本地的 AFNetworking，无需用户额外操作
```

### 完善的插件化

MBox 全程使用插件技术开发，MBox 本身也是使用 MBox 开发，因此，MBox 能不断通过插件技术扩充更多的能力，也能自己开发符合自己团队的插件。

## 安装
```
$ brew tap MBoxPlus/homebrew-tap

$ brew install mbox
```
> 你必须先安装 [Homebrew](https://brew.sh/)

## 关于仓库

这个仓库不包含 MBox 源码，在这里我们会发布产品、里程碑和工作计划，同时我们的用户可以在这里查找文档或提交 issue。

## 开始使用

一些概念和术语（比如 Workspace, Feature, Container 等等）解释在[这里](https://github.com/MBoxPlus/mbox/wiki/MBox-terminology-cn) 。

### iOS

- [快速开始 Demo](doc/quick_start_demo_ios.md)

- [iOS 项目接入与使用](./doc/getting_started_ios.md)

### Android
*Work in Progress*

### Flutter
*Work in Progress*

## 高级使用

- [使用指南](https://github.com/MBoxPlus/mbox/wiki/Tutorial-cn)
  
- [CLI 文档](https://github.com/MBoxPlus/mbox/wiki/CLI-documentation)

## 参与项目
你有多种方式来参与这个项目。
- [提交 bug 与 feature](https://github.com/MBoxPlus/mbox/issues)
- [审阅提交](https://github.com/MBoxPlus/mbox/pulls)

## 项目开发文档

- [构建](doc/build.md)

- [发布](doc/release.md)

## 讨论
- 微信号: 123649881
- 邮箱: mbox.develop@gmail.com
- [加入MBox飞书群](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=fb2k24b7-a10f-40d3-85a4-cd31abc6f3e2)
<p align="left"><img src="doc/wechat.jpeg" alt="Wechat group" width="320px"></p>

## 开源许可
MBox 开源许可基于 [GNU General Public License v2.0 or later](./LICENSE).
