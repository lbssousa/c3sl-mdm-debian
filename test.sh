#!/bin/bash

# Copyright (C) 2004-2007 Centro de Computacao Cientifica e Software Livre
# Departamento de Informatica - Universidade Federal do Parana - C3SL/UFPR
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.

# This is just a lazy script that:
#    - downloads the mdm git repository
#    - generates a .tar.gz for it
#    - puts our 'debian' directory inside the .tar.gz
#    - uses 'debuild' to build the packages
# Everything is done inside the 'tmp' directory

set -e
set -x

if [ -d 'tmp' ]; then
    echo "'tmp' directory already exists"
    exit 1
fi

# Download mdm
mkdir tmp
cd tmp
git clone http://git.c3sl.ufpr.br/pub/scm/multiseat/mdm.git

# Remove 'git' stuff
cd mdm
rm -rf .git
find . -type f -name '.gitignore' -exec rm -f '{}' \;

# Create the .tar.gz
VERSION=$(grep '^MDM_VERSION=' mdm/src/mdm-common | cut -d\' -f2)
cd ..
mv mdm mdm-${VERSION}
tar cvzf mdm_${VERSION}.orig.tar.gz mdm-${VERSION}

# Put the debian stuff there
cp -r ../debian mdm-${VERSION}/

# Create the package
cd mdm-${VERSION}
debuild
