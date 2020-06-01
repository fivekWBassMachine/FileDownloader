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

# some useful foreground color codes
# some are commented out due to performance reasons...
COL_CLEAR='\e[0m'
#COL_BLACK='\e[0;30m'
COL_RED='\e[0;31m'
COL_GREEN='\e[0;32m'
#COL_BROWN='\e[0;33m'
COL_BLUE='\e[0;34m'
#COL_PURPLE='\e[0;35m'
#COL_CYAN='\e[0;36m'
COL_LGRAY='\e[0;37m'
COL_DGRAY='\e[1;30m'
#COL_LRED='\e[1;31m'
#COL_LGREEN='\e[1;32m'
#COL_YELLOW='\e[1;33m'
#COL_LBLUE='\e[1;34m'
#COL_LPURPLE='\e[1;35m'
#COL_LCYAN='\e[1;36m'
COL_WHITE='\e[1;37m'

# return values:
#  0: success
#  1: failed
#  2: precondition failed

# log messages
function info() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_BLUE}i${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[i] [${d}] ${1}\n" >> $logfile
}
function error() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_RED}✗${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[✗] [${d}] ${1}\n" >> $logfile
}
function success() {
	d=`date '+%FT%T:%2N'`
	echo -e "${COL_WHITE}[${COL_GREEN}✓${COL_WHITE}]${COL_LGRAY} [${d}]${COL_LGRAY} ${1}${COL_DGRAY}"
	echo "[✓] [${d}] ${1}\n" >> $logfile
}

# creates dir $1 if not existent
function create_dir() {
	if [ ! -d $1 ]; then
		info "Creating directory '$1'..."
		mkdir -p $1
		if [ $? -eq 0 ]; then
			success "Done."
			return 0
		else
			error "Can't create directory."
			return 1
		fi
	fi
}

# removes dir $1 if eistent
function remove_dir() {
	if [ -d $1 ]; then
		info "Removing directory '$1'..."
		rm -r $1
		if [ $? -eq 0 ]; then
			success "Done."
			return 0
		else
			error "Can't remove directory."
			return 1
		fi
	fi
}

# move all files in dir $1 to dir $2
function move_files_in_dir() {
	if [ -d $1 ] && [ -d $2 ]; then
		src=$1*; if [[ "$1" != */ ]]; then src=$1/*; fi
		info "Moving '$src' to '$2'..."
		mv $src $2
		if [ $? -eq 0 ]; then
			success "Done."
			return 0
		else
			error "Can't move files."
			return 1
		fi
	else
		error "Can't move files. (the source or target directory isn't valid)"
		return 2
	fi
}

# downloads a file $1 using wget
function download_file() {
	info "Downloading file '$1'..."
	wget $1 -O $2
	if [ $? -eq 0 ]; then
		success "Done."
		return 0
	else
		error "Can't download file."
		return 1
	fi
}

# proves wether a file $2 has the same checksum as $1 using md5sum
function check_checksum() {
	if [ -z $1 ]; then
		error "Empty checksum."
		return 1
	fi
	if [ ! -e $2 ]; then
		error "No such file: $2"
		return 1
	fi
	info "Getting md5 checksum of '$2'..."
	IFS="  " read -ra checksum <<< $(md5sum $2)
	if [ ${checksum[0]} = $1 ]; then
		success "Done. Checksums match."
		return 0
	else
		error "Done. Checksums don't match."
		return 1
	fi
}

# decodes url encodings to characters (e.g. '%2B' to '+')
function urldecode() { : "${*/// }"; echo -e "${_//%/\\x}"; }

# replaces ' ' with '\ '
function escape_spaces() { echo ${1//" "/"\\ "}; }

# removes all temporary files and dirs and exits with $1
function clean_exit() {
	remove_dir $tmp_dir
	info "Script exited with code $1$COL_CLEAR"
	exit $1
}

filename=$0

if [ -z $2 ]; then
	# show usage when less than 2 arguments are given.
	echo "$filename copyright 5kWBassMachine 2020"
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
	exit 2
else
	# init
	working_dir=$(pwd)
	tmp_dir="$working_dir/tmp_`date '+%FT%H-%M-%S'`"
	
	# get logfile
	logfile="${working_dir}/${filename}.log"
	
	# start real script execution
	
	# create temporary dir & cd to it
	create_dir $tmp_dir
	if [ $? -ne 0 ]; then clean_exit 1; fi
	
	cd $tmp_dir
	if [ $? -ne 0 ]; then error "Can't cd to '$tmp_dir'"; clean_exit 1; fi
	
	# get filelist
	info "Downloading filelist..."
	filelist="`wget -O- $1`"
	if [ $? -ne 0 ]; then error "Can't download filelist"; clean_exit 1; else success "Done."; fi
	
	# iterate through each entry in filelist
	for line in $filelist; do
		if [[ $line == \#* ]]; then
			# skip entries starting with a '#'
			info "Skipping comment."
		else
			# get checksum, url and name
			IFS='|' read -ra line_parts <<< "$line"
			checksum=${line_parts[0]}
			url=${line_parts[1]}
			IFS='/' read -ra url_parts <<< "$url"
			name=${url_parts[-1]}
			name=$(urldecode $name)
			name=$(escape_spaces "$name")
			
			# download the entry
			download_file $url "$name"
			if [ $? -ne 0 ]; then clean_exit 1; fi
			
			# prove the entry
			check_checksum $checksum "$name"
			if [ $? -ne 0 ]; then clean_exit 1; fi
		fi
	done
	info "All files downloaded and validated."
	
	cd $working_dir
	
	# create target dir if not existent
	create_dir $2
	if [ $? -ne 0 ]; then clean_exit 1; fi
	move_files_in_dir $tmp_dir $2
	if [ $? -ne 0 ]; then clean_exit 1; fi
	
	# success message
	entries=( $filelist )
	success "${COL_GREEN}Successfully downloaded and verified ${#entries[@]} files."
	info "The files are in '$2'"
	
	# exit programm
	clean_exit 0
fi
