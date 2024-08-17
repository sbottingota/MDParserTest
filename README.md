# MDParserTest
## A very simple markdown to html parser I made using awk.

---
Run like:
```sh
$ awk -f parser.awk [input markdown file]
```
or if you want to print to a file instead of to stdout:
```sh
$ awk -f parser.awk [input markdown file] > [output html file]
```
---

List of current features:
- Headers (# - ###### &rarr; &lt;h1&gt; - &lt;h6&gt;)
- Horizontal rules (---|\*\*\*|\_\_\_ &rarr; &lt;hr/&gt;)

