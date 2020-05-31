# FileDownloader

_A bunch of scripts do download multiple files programmatically_

## Script Usage

The following commands will download all files in `myfiles.filelist` to the directory `./temp`.

### Linux

`./filedownloader.sh https://example.com/myfiles.filelist ./target_dir`<br>
(This tool uses requires wget to download the files)

**Tested under:**

- Kubuntu 18.04 LTS \[PC\]

### Windows

`filedownloader.exe https://example.com/myfiles.filelist target_dir`<br>
`py -m filedownloader.py https://example.com/myfiles.filelist target_dir`<br>
(The exe is basically the python script, converted with [pyinstaller](https://www.pyinstaller.org))

**.exe Tested under:**

- Windows 10 Pro (64 bit) \[VM\]


**.py Tested under:**

- Windows 10 Pro (64 bit) \[VM\]

## Filelist Usage

`<MD5 CHECKSUM>|<URL>`

```
#first_is_the_md5_checksum______|second_is_the_url_to_the_instant_download
b50d4f3b95d2b885a7e7d8c3834d5a05|https://example.com/downloads/fileA.txt
#this_will_be_ignored
e1bcbbbfd06f24d614cf81136f7cca98|https://example.com/downloads/fileB.txt
cfb81e893a86d663b9d9111a8579c7b5|https://example.com/downloads/test.jar
850ca6dde9ecb94c946e0db524105eb3|https://example.com/downloads/hello.exe
54024193e64c89587a6afb3bbbcd8521|https://example.com/downloads/world.sh
```

### Syntax

1. Seperate the entries with line breaks and/ or spaces
2. Entries starting with `#` will be ignored
3. Empty lines will be ignored.

### Directory

If you have such a file, the directory would look like:

- `fileA.txt`
- `fileB.txt`
- `test.jar`
- `hello.exe`
- `world.sh`

# License/ Contributing

Feel free to redistribute or contribute under the terms of the GNU GPL v3 license if you like the project.
