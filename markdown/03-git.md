# git

I mostly use **plain Git** instead of tools like Git Kraken or something.
For a large part of the work this works well, but some actions I don't do that often.

This is a short but growing list.

<!--more-->

## pull a squashed branch

If you want to pull **a squashed branch**, a git pull will cause **a merge conflict**.
If you don't have **any changes in your local branch**, you can do a **fetch and rebase**.

```
$ git fetch --all
$ git reset --hard {branchname}
```

## rebase origin/master into an older branch

When you try to rebase `origin/master` in an older branch, you certainly get merge conflicts.

```
$ git rebase origin/master
```

When you think, that the master **is always right**, you can checkout the master version of the files by

```
$ for i in $(git status | grep "both modified" | awk '{ print $3}'); do git checkout --ours $i; done
$ git add .
```

When you take a look at the stage again

```
$ git status
```

and everythings looks ok, you can **continue the rebase**

```
$ git rebase --continue
```

Before making a **force push** check the state again.

```
$ git status
```

When the state looks ok, you can do a **force push**

```
$ git push --force
```
