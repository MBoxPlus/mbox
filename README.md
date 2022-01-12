# MBox - Toolchain for Mobile App Development

![Version](https://img.shields.io/github/v/release/mboxplus/mbox)
![Total Downloads](https://img.shields.io/github/downloads/mboxplus/mbox/total)
![License](https://img.shields.io/github/license/mboxplus/mbox)

[简体中文](./README-CN.md) | **English**

MBox is a toolchain App on macOS which focuses on Mobile App Development. It can help developers manage environments, dependencies, or repositories. Besides, developers can customize their tools or workflow by developing an MBox Plugin.

## The Repository

This repository is the repo without any source code of MBox. It is where we publish products, milestones, and work plans. Also, our users search documents and submit issues here.

MBox uses plug-in technology. By adding plug-ins, MBox can continuously expand its capabilities.

There are some core plugin:

1. [MBoxCore](https://github.com/MBoxPlus/mbox-core) The MBox kernel, load plugins and distribut commands.
1. [MBoxGit](https://github.com/MBoxPlus/mbox-git) Provide the git support, this is a kernel, too. The `GitHelper` and `GitCMD` will be usefully.
1. [MBoxWorkspace](https://github.com/MBoxPlus/mbox-workspace) The workspace plugin，will provide the multi-repository support, include feature management.
1. [MBoxRuby](https://github.com/MBoxPlus/mbox-ruby) Support the Ruby and Bundler, which provide `mbox bundle` command.
1. [MBoxContainer](https://github.com/MBoxPlus/mbox-container) 
If there are multi-app in a workspace, this plugin allow user select a container as the main app
1. [MBoxDependencyManager](https://github.com/MBoxPlus/mbox-dependency-manager) Dependency Manager Plugin, this is a kernel.
1. [MBoxCocoapods](https://github.com/MBoxPlus/mbox-cocoapods) Extend `MBoxDependencyManager` and `MBoxContainer` plugins, support for the cocoapods component and container.
1. [MBoxDev](https://github.com/MBoxPlus/mbox-dev) MBox Development Tool. The MBox develop the MBox.
1. [MBoxDevRuby](https://github.com/MBoxPlus/mbox-dev-ruby) Develop the Ruby component of MBox.
1. [MBoxDevNative](https://github.com/MBoxPlus/mbox-dev-native) Develop the Native component of MBox, include the CLI.

## Installation
```
$ brew tap MBoxPlus/homebrew-tap

$ brew install mbox
```
> You need to [Install Homebrew](https://brew.sh/) first.

## Getting Started

Concepts and terminology (e.g. a Workspace, Feature, Container and so forth) is explained [here](https://github.com/MBoxPlus/mbox/wiki/MBox-terminology).

### iOS

- [Quick Start Demo](https://github.com/MBoxPlus/mbox/wiki/Quick-Start-Demo-iOS)

- [Getting Started for iOS](https://github.com/MBoxPlus/mbox/wiki/Getting-Started-iOS)

### Android
*Work in Progress*

### Flutter
*Work in Progress*

## Links

|  Name   | Description  |
|  ----  | ----  |
| [Tutorial](https://github.com/MBoxPlus/mbox/wiki/Tutorial) | More advanced usage |
| [CLI documentation](https://github.com/MBoxPlus/mbox/wiki/CLI-documentation) | Command line tools documentation |

## Contributing
You have many ways to participate in this project.
- [Submit bugs or feature requests](https://github.com/MBoxPlus/mbox/issues)
- [Review pull requests](https://github.com/MBoxPlus/mbox/pulls)

Refer to [CONTRIBUTING](CONTRIBUTING.md)

## Discuss
- WeChat: 123649881
- Email: mbox.develop@gmail.com
- [Contact us with lark](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=fb2k24b7-a10f-40d3-85a4-cd31abc6f3e2)
<p align="left"><img src="doc/wechat.png" alt="Wechat group" width="320px"></p>

## License
MBox is available under [GNU General Public License v2.0 or later](./LICENSE).
