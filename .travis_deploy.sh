# credentials for GitHub repo
git remote set-url origin https://$GITHUB_ACCESS_TOKEN@github.com/bartoszek/AUR-repo.git

# test if local HEAD in sync with remote
git checkout master || { echo "Drop db update - since new package get pushed to repo" >&2; exit 1; }

git add bartus.* *.pkg.tar.xz
git status
git commit -a -m "update repo db [skip ci]"
git push
