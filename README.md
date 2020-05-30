# FileDownloader

_A bunch of scripts do download multiple files programmatically_

## Script Usage

The following commands will download all files in `myfiles.filelist` to the directory `./temp`.

### Linux

`./filedownloader.sh https://example.com/myfiles.filelist ./temp`<br>
(This tool uses requires wget to download the files)

**Tested under:**

- Kubuntu 18.04 LTS \[PC\]

### Windows

**NOT IMPLEMENTED YET! - Comming soon**<br>
`start filedownloader.batch https://example.com/myfiles.filelist .\temp`<br>
(This tool abueses certutil.exe to download the files)

**Tested under:**

- Windows 7 Home Premium SP1 (32 bit) \[VM\]
- Windows 10 Pro (64 bit) \[PC\]

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
