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

```
https://example.com/downloads/fileA.txt
#this_will_be_ignored
https://example.com/downloads/fileB.txt
https://example.com/downloads/test.jar
https://example.com/downloads/hello.exe
https://example.com/downloads/world.sh
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
