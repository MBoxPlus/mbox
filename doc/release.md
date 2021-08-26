# Release

## Release MBox

- If you allow to bump plugins' version automatically, skip it. If you don't want to bump version automatically, you need to change the plugins' version in `mbox-package.yml` file.

- Open `GitHub Action` page on the repo `MBoxPlus/mbox`.

- Choose branch 'main' and pass the **semantic version** (like "1.0.0") to the input field `Version of Release`. If you don't want to bump version automatically, pass **false** to the input field `Bump Plugin Version`.

- Click the button `Run workflow`.

![img_1.png](img_1.png)

## Release Plugin

- Open `GitHub Action` page on the plugin repo `MBoxPlus/mbox-xxx`.

- Choose branch 'main'.

- Click the button `Run workflow`.

![img.png](img.png)