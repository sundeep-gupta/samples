#!sh
git config --global user.name "Sundeep Gupta"
git config --global user.email "sundeep.gupta@oracle.com"
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global pull.rebase true
git config --global push.default current
git config --global alias.uncommit 'reset --soft HEAD^'
git config --global alias.incoming '!git fetch && git log --pretty=oneline --abbrev-commit --graph ..@{u}'
git config --global alias.outgoing 'log --pretty=oneline --abbrev-commit --graph @{u}..'
