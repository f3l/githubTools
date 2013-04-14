#!/bin/bash
#################################################################
#
# Copyright (c) 2013 Timo Tomasini <timo@tomasini-mail.de>
#
# License:
#       This program is free software; you can redistribute
#       it and/or modify it under the terms of the
#       GNU General Public License as published by the Free
#       Software Foundation; either version 2 of the License,
#       or (at your option) any later version.
#
#       This program is distributed in the hope that it will
#       be useful, but WITHOUT ANY WARRANTY; without even the
#       implied warranty of MERCHANTABILITY or FITNESS FOR A
#       PARTICULAR PURPOSE. See the GNU General Public
#       License for more details.
#
#       You should have received a copy of the GNU General
#       Public License along with this program; if not,
#       write to the Free Software Foundation, Inc., 59
#       Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#       An on-line copy of the GNU General Public License can
#       be downloaded from the FSF web page at:
#       http://www.gnu.org/copyleft/gpl.html
#
# Description:
#    Simple bash script to upload existing code to github and
#    to create a new repository
#
# Usage:
#    To run this script, place it into your project root
#    folder and run it 
#
# Version: 0.1
#
# Requirements:
#    unix-like system, git, curl
#
#################################################################

# configuration; docs see http://developer.github.com/v3/repos/#create
PRIVATE=false
HAS_ISSUES=true
HAS_WIKI=true
HAS_DOWNLOADS=true

# Do not edit below
echo "Please enter your github username"
read username
echo "Please enter your desired projectname"
read projectname
echo "Please enter a description for $projectname"
read description
curl -s -u "$username" -d "{\"name\":\"$projectname\",\"description\":\"$description\",\"private\":$PRIVATE,\"has_issues\":$HAS_ISSUES,\"has_wiki\":$HAS_WIKI,\"has_downloads\":$HAS_DOWNLOADS}" https://api.github.com/user/repos | grep '"url":'

if [ "$?" == "0" ] ; then
	git init
	git add ./*
	git add ./.*
	git reset -- `basename $0`
	git commit -m 'initial commit'
	git remote add origin git@github.com:$username/"$projectname".git
	git push -u origin master
	return 0
else
	echo "Wrong statement(s); exit 1"
	return 1
fi
