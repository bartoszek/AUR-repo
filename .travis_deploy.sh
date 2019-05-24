git remote set-url origin https://$GITHUB_ACCESS_TOKEN@github.com/bartoszek/AUR-repo.git
git checkout master
git add bartus.* *.pkg.tar.xz
git status
#git config user.name "Travis Ci User"
#git config user.email travis@example.org
git commit -a -m "rebuild repo db afet $pkgname update [skip ci]"
git push
