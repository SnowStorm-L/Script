#! /bin/bash

# 作用:
# 同步fork的远程仓库

# 使用方法:
# 1, 把远程仓库克隆到本地, cd 到 .git 的目录下
# 2, 把sync-fork.sh 放到 和 .git 文件同个目录下
# 3, xxx/xxx/sync-fork.sh url(远程仓库url)

url="$1"
git remote add upstream $url
git fetch upstream
git merge upstream/master
git push
