git add *
git commit -m "$(date) update commit messages is $*" *
git push notes_gitee master
git push notes_github master
