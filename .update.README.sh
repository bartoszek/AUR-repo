#!/bin/bash
# sed -n '1,/<!--begin-->/p;/<!--end-->/,$p' README.md

_tab_header='| Package | Status | \#No|\n|--:|:--|--:|'

_tab_entry_template='echo \| \[$pkgname\]\(https://github.com/bartoszek/AUR-$pkgname\)\| \[!\[Build Status $pkgname\]\(https://travis-ci.org/bartoszek/AUR-$pkgname.svg\)\]\(https://travis-ci.org/bartoszek/AUR-$pkgname\) \| $update_count \|'

# Pull all commits for stats gathering
git pull --unshallow

# Drop previous status table
sed -i '/<!--begin-->/,/<!--end-->/{/<!--begin-->/!{/<!--end-->/!d}}' README.md

# Add headers
sed -i "/<!--end-->/i $_tab_header" README.md

# Generate status table
xzcat bartus.db|grep -a -A1 %NAME%|paste -d " " - - -|\
  while read _ pkgname _ ; do
    echo $pkgname;
    update_count=$(git rev-list --grep="build_log.*$pkgname" --pretty="%s %b" HEAD --count)
#   last_update=$(git rev-list --grep="build_log.*$pkgname" --pretty="%cr" HEAD -1|tail -n1|sed 's/ ago//')
    tab_entry=$(eval $_tab_entry_template);
    sed -i "/<!--end-->/i $tab_entry" README.md
  done
