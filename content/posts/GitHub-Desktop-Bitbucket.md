---
title: Clone Bitbucket Repository and Add it to GitHub Desktop App (Mac)
date: 2015-10-18
tags:
- Git
- GitHub
- Bitbucket
---
You [can’t clone](http://stackoverflow.com/a/32213131/2613447) a Bitbucket repo using [GithHub Desktop](https://desktop.github.com/) directly. Instead you would have to:

1. Clone the Bitbucket repo locally via command line.
2. Add the cloned repository to your GitHub Desktop app.

After completing these 2 steps, you’ll be able to execute sync, push, pull, commit, and other git commands available in GitHub Desktop for your Bitbucket repository just as you would for any GitHub repository.

_You will need your Bitbucket repository’s git URL as available on the **Overview** page of your repository:_

![Retrieve git URL from Bitbucket.org](https://cloud.githubusercontent.com/assets/308422/13249267/a3407f8a-da23-11e5-93ab-32c4a5fb501b.png)

<!-- more -->

## 1. Clone Bitbucket Repository Locally via Command Line

1. Open Terminal app.
2. Type `cd /Local/path/to/parent-folder/to/clone/into` (replacing that sample path with the local path to the parent folder you want to clone your Bitbucket repository into).
3. Hit enter. You’ve just opened that parent folder on the command line.
4. Type `git clone https://example@bitbucket.org/path/to/your-repo.git` (replacing that sample URL with the Bitbucket URL available on the **Overview** page of your repository).
5. Hit enter and watch the repository being cloned. (Once it’s done, it’ll say something like **…done** in one of the last lines.)

## 2. Add Cloned Repository to Your GitHub Desktop App
1. Open GitHub Desktop.
2. In the upper right corner (if your sidbar is open) press the large **+** button.
3. Select **Add** to add an exisiting local repository.
4. On the **Add** tab click the **Choose…** button, navigate to the folder you have just cloned your Bitbucket repository into, and select it.

   ![“Add” tab in GitHub Desktop](https://cloud.githubusercontent.com/assets/308422/13249268/a342b1e2-da23-11e5-870f-f6ee0efd1b86.png)

5. Your newly added repository will appear at the bottom of your sidebar in the **Other** section.

**That’s it.**
You should now be able execute git operations on your Bitbucket repository via your GitHub Desktop app just as on any GitHub repository.