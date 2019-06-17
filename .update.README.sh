#!/bin/bash
# sed -n '1,/<!--begin-->/p;/<!--end-->/,$p' README.md

# Define template
#######################################################################
_tab_header='| Package | Status | Version | \#No|\n|--------:|:-------|:--------|----:|'

_tab_entry_template='echo'
_tab_entry_template+=' \| \[$pkgname\]\(https://github.com/bartoszek/AUR-$pkgname\)\| \[!\[Build Status $pkgname\]\(https://travis-ci.org/bartoszek/AUR-$pkgname.svg\)\]\(https://travis-ci.org/bartoszek/AUR-$pkgname\)'
_tab_entry_template+=' \| \[!\[AUR package\]\(https://repology.org/badge/version-only-for-repo/aur/${pkgname%-git}.svg\)\]\(https://repology.org/project/${pkgname%-git}/versions\)'
_tab_entry_template+=' \|  $update_count'
_tab_entry_template+=' \|'
#######################################################################

# Define exceptions
#######################################################################
_exceptions=('s/blender-2.8.svg/blender.svg/g'
             's|blender-2.8/versions|blender/versions|g'
)
#######################################################################

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

# Fix exceptions
sed -i $(printf " -e %s" ${_exceptions[@]}) README.md
