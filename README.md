# MDParserTest
## A very simple markdown to html parser I made using awk.

---
Run like:  
```sh
$ ./parser.pl [input md file]
```
or if you want to print to a file instead of to stdout:
```sh
$ ./parser.pl [input md file] > [output html file]
```
---

List of current features:  
- Headers (# - ######)
- Horizontal rules (---|\*\*\*|\_\_\_)
- Line breaks (line with two spaces at the end)
- Bold and italic text (using \* or \_)
