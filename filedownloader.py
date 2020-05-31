#!/usr/bin/env python3

import sys
from datetime import datetime
import os
import shutil
import requests
import hashlib
import urllib.parse

# return values:
#  0: success
#  1: failed
#  2: precondition failed

# log messages
def info(message):
	d = datetime.now().isoformat()
	log("[i] [" + d + "] " + message)
def error(message):
	d = datetime.now().isoformat()
	log("[✗] [" + d + "] " + message)
def success(message):
	d = datetime.now().isoformat()
	log("[✓] [" + d + "] " + message)
def log(m):
	global logfile
	print(m)
	with open(logfile, "a") as f:
		f.write(m)

# creates dir $1 if not existent
def createDir(directory):
	if not os.path.isdir(directory):
		info("Creating directory '" + directory + "'...")
		try:
			os.makedirs(directory)
			success("Done.")
			return 0
		except:
			error("Can't create directory.")
			return 1
	return 0

# removes dir $1 if not existent
def removeDir(directory):
	if os.path.isdir(directory):
		info("Removing directory '" + directory + "'...")
		try:
			shutil.rmtree(directory)
			success("Done.")
			return 0
		except:
			error("Can't remove directory.")
			return 1
	return 0

# move all files in dir $1 to dir $2
def moveFilesInDir(src, dst):
	if os.path.isdir(src) and os.path.isdir(dst):
		info("Moving '" + src + "' to '" + dst + "'...")
		try:
			files = os.listdir(src)
			for f in files:
				shutil.move(src + f, dst)
			success("Done.")
			return 0
		except:
			error("Can't move files.")
			return 1
	else:
		error("Can't move files. (the source or target directory isn't valid)")
		return 2

# downloads a file $1 using wget
def downloadFile(url, name):
	info("Downloading file '" + url + "'...")
	try:
		r = requests.get(url)
		if not r.status_code == 200:
			error("Can't download file.")
			return 1
		with open(name, 'wb') as f:
			f.write(r.content)
		success("Done.")
		return 0
	except:
		error("Can't download file.")
		return 1

def downloadFileToVar(url):
	info("Downloading file '" + url + "'...")
	try:
		r = requests.get(url)
		if not r.status_code == 200:
			raise Exception()
		success("Done.")
		return r.content
	except:
		error("Can't download file.")
		raise Exception()

# proves wether a file $2 has the same checksum as $1 using md5sum
def checkChecksum(checksum, filename):
	info("Getting md5 checksum of '" + filename + "'...")
	try:
		hashMD5 = hashlib.md5()
		with open(filename, "rb") as f:
			for chunk in iter(lambda: f.read(4096), b""):
				hashMD5.update(chunk)
		if hashMD5.hexdigest() == checksum:
			success("Done. Checksums match.")
			return 0
		else:
			error("Done. Checksums don't match.")
			return 1
	except:
		error("Can't read checksum.")
		return 1

# removes all temporary files and dirs and exits with $1
def cleanExit(code):
	global tmpDir
	removeDir(tmpDir)
	info("Script exited with code " + str(code))
	sys.exit(code)

if len(sys.argv) != 3:
	print(__file__ + " copyright 5kWBassMachine 2020")
	print("ARGUMENTS:")
	print(" $1: url to the files repository (*.filelist)")
	print(" $2: path to the download directory")
	print("EXIT:")
	print(" 0:   success")
	print(" 1:   error")
	print(" 2:   misusage")
	print("LICENSE:")
	print(" this script comes without any warranty and reliablility")
	print(" this script is licensed under the gnu general public license")
	print(" https://www.gnu.org/licenses/gpl-3.0.txt")
else:
	# init
	filelistUrl = sys.argv[1]
	workingDir = os.path.dirname(os.path.realpath(__file__))
	targetDir = workingDir + "/" + sys.argv[2]
	tmpDir = workingDir + "/tmp_" + datetime.now().strftime("%FT%H-%M-%S") + "/"
	
	# get logfile
	logfile = workingDir + "/" + __file__.split("/")[-1].split(".")[0] + ".log"
	
	# start real script execution
	
	# create temporary dir
	
	if createDir(tmpDir) == 1:
		cleanExit(1)
	
	filelist=""
	try:
		filelist = downloadFileToVar(filelistUrl).decode("utf-8")
		if filelist == "":
			error("Filelist is empty")
			cleanExit(1)
	except:
		cleanExit(1)
	filelist = filelist.split("\n")
	for line in filelist:
		if line == "":
			continue
		if line.startswith("#"):
			# skip entries starting with a '#'
			info("Skipping comment")
		else:
			# get checksum, url and name
			line = line.split("|")
			checksum = line[0]
			url = line[1]
			name = tmpDir + urllib.parse.unquote(url.split("/")[-1])
			
			# download the entry
			if downloadFile(url, name) == 1:
				cleanExit(1)
			
			# prove the entry
			if checkChecksum(checksum, name) == 1:
				cleanExit(1)
	info("All files downloaded and validated.")
	
	# create target dir if not existent
	if createDir(targetDir) == 1:
		cleanExit(1)
	if moveFilesInDir(tmpDir, targetDir) == 1:
		cleanExit(1)
	
	# success message
	success("Successfully downloaded and verified " + str(len(filelist)) + " files.")
	info("The files are in '" + targetDir + "'")
	
	# exit programm
	cleanExit(0)
