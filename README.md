# FileDownloader
_A bunch of scripts do download multiple files programmatically_

## Script Usage
The following commands will download all files in `myfiles.filelist` to the directory `./temp`.
### Linux
`./filedownloader.sh https://example.com/myfiles.filelist ./temp`<br>
(This tool uses requires wget to download the files)
### Windows
**NOT IMPLEMENTED YET! - Comming soon**
`start filedownloader.batch https://example.com/myfiles.filelist .\temp`
(This tool abueses certutil.exe to download the files)

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

# License/ Contributing
Feel free to redistribute or contribute under the terms of the GNU GPL v3 license if you like the project.
