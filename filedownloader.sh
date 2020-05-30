#!/bin/bash

#  filedownloader.sh (v1.0.0)
#  
#  Copyright 2020 5kWBassMachine <5kWBassMachine@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

COL_CLEAR='\e[0m'
COL_BLACK='\e[0;30m'
COL_RED='\e[0;31m'
COL_GREEN='\e[0;32m'
COL_BROWN='\e[0;33m'
COL_BLUE='\e[0;34m'
COL_PURPLE='\e[0;35m'
COL_CYAN='\e[0;36m'
COL_LGRAY='\e[0;37m'
COL_DGRAY='\e[1;30m'
COL_LRED='\e[1;31m'
COL_LGREEN='\e[1;32m'
COL_YELLOW='\e[1;33m'
COL_LBLUE='\e[1;34m'
COL_LPURPLE='\e[1;35m'
COL_LCYAN='\e[1;36m'
COL_WHITE='\e[1;37m'

# return values:
#  0: success
#  1: failed

function info() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_BLUE}i${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[i] [${d}] ${1}" >> $working_dir/filedownloader.log
}
function error() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_RED}✗${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[✗] [${d}] ${1}" >> $working_dir/filedownloader.log
}
function success() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_GREEN}✓${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[✓] [${d}] ${1}" >> $working_dir/filedownloader.log
}

function show_usage() {
	echo "filedownloader.sh copyright 5kWBassMachine 2020"
	echo "ARGUMENTS:"
	echo " \$1: url to the files repository (*.filelist)"
	echo " \$2: path to the download directory"
	echo "EXIT:"
	echo " 0:   success"
	echo " 1:   error"
	echo " 2:   misusage"
	echo "LICENSE:"
	echo " this script comes without any warranty and reliablility"
	echo " this script is licensed under the gnu general public license"
	echo " https://www.gnu.org/licenses/gpl-3.0.txt"
}

function create_dir() {
	if [ ! -d $1 ]; then
		info "Creating directory '$1'..."
		mkdir -p $1
		if [ $? -eq 0 ]; then
			success "Done."
		else
			error "Can't create directory."
			exit 1
		fi
	fi
}

function download_file() {
	info "Downloading file '$1'..."
	wget $1
	if [ $? -eq 0 ]; then
		success "Done."
	else
		error "Can't download file."
		exit 1
	fi
}

if [ -z $2 ]; then
	show_usage
	exit 2
else
	working_dir=$(pwd)
	
	create_dir $2
	if [ $? -ne 0 ]; then exit 1; fi
	
	cd $2
	if [ $? -ne 0 ]; then exit 1; fi
	
	info "Downloading filelist..."
	file_list="`wget -O- $1`"
	if [ $? -ne 0 ]; then exit 1; else success "Done."; fi
	
	for file_url in $file_list; do
		if [[ $file_url == \#* ]]; then
			info "Skipping comment."
		else
			IFS='/' read -ra file_url_parts <<< "$file_url"
			file_name=${file_url_parts[-1]}
			download_file $file_url $file_name
		fi
	done
fi
