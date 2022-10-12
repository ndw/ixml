"""Crude syntax highlighter for Invisible XML.
This script is a bit cheap-and-cheerful. It works for the ixml.ixml grammar
but may not work for arbitrary grammars.
"""

import sys

class Highlighter:
    """The Highlighter class parses ixml.xml and turns it into nested HTML spans."""

    def __init__(self, filename):
        self._text = ""
        self._html = ""
        self._pos = 0
        with open(filename, "r", encoding="utf-8") as ixml:
            for line in ixml:
                self._text = self._text + line

    def highlight(self):
        """Highlight the input."""
        self._html = "<span>"
        while self._pos < len(self._text):
            ch = self._text[self._pos]
            if ch == "{":
                self._comment()
            elif ch == "[" or (ch == '~' and self._text[self._pos+1] == '['):
                if ch == '~' and self._text[self._pos+1] == '[':
                    self._html += "<span class='set'><span class='sedel'>~[</span>"
                    self._pos += 1
                else:
                    self._html += "<span class='set'><span class='sedel'>" + ch + "</span>"
                self._pos += 1
            elif ch == "]":
                self._html += "<span class='sedel'>" + ch + "</span></span>"
                self._pos += 1
            elif ch == "#":
                self._hex()
            elif ch in ("\"", "'"):
                self._string()
            elif ch in (" ", "\n"):
                self._html += ch
                self._pos += 1
            elif (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z'):
                self._nonterminal()
            elif ch == ":":
                self._html += "<span class='col'>" + ch + "</span>"
                self._pos += 1
            elif ch in (",", ".", "(", ")"):
                self._html += ch
                self._pos += 1
            elif ch in (";", "|"):
                self._html += "<span class='alt'>" + ch + "</span>"
                self._pos += 1
            elif ch in ("-", "@", "^"):
                self._html += "<span class='mark'>" + ch + "</span>"
                self._pos += 1
            elif ch == "?" or (ch == "+" and not self._text[self._pos+1] == "+") \
              or (ch == "*" and not self._text[self._pos+1] == "*"):
                self._html += "<span class='rep'>" + ch + "</span>"
                self._pos += 1
            elif ch in ("+","*") and self._text[self._pos+1] == ch:
                self._html += "<span class='reps'>" + ch + ch + "</span>"
                self._pos += 2
            else:
                print(self._html)
                print("Unexpected:", ch)
                sys.exit(1)
        self._html += "</span>"

    def text(self):
        """Return the input ixml."""
        return self._text

    def html(self):
        """Return the parsed ixml as HTML."""
        if self._html == "":
            self.highlight()
        return self._html

    def _comment(self):
        self._html += "<span class='com'>"
        self._html += "<span class='comdel'>{</span>"
        self._pos += 1
        while self._text[self._pos] != '}':
            self._html += self._text[self._pos]
            self._pos += 1
        self._pos += 1
        self._html += "<span class='comdel'>}</span>"
        self._html += "</span>"

    def _nonterminal(self):
        self._html += "<span class='nt'>"
        self._html += self._text[self._pos]
        self._pos += 1
        ch = self._text[self._pos]
        while (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9'):
            self._html += ch
            self._pos += 1
            ch = self._text[self._pos]
        self._html += "</span>"

    def _hex(self):
        self._html += "<span class='hex'>"
        self._html += self._text[self._pos]
        self._pos += 1
        ch = self._text[self._pos]
        while ('a' <= ch <= 'f') or ('A' <= ch <= 'F') or ('0' <= ch <= '9'):
            self._html += ch
            self._pos += 1
            ch = self._text[self._pos]
        self._html += "</span>"

    def _string(self):
        self._html += "<span class='str'>"

        q = self._text[self._pos]
        self._html += "<span class='strdel'>" + q + "</span>"

        self._pos += 1
        ch = self._text[self._pos]

        while ch != q or (ch == q and self._text[self._pos+1] == q):
            if ch == q and self._text[self._pos+1] == q:
                self._html += ch + ch
                self._pos += 2
            else:
                self._html += ch
                self._pos += 1
            ch = self._text[self._pos]

        self._pos += 1

        self._html += "<span class='strdel'>" + q + "</span>"
        self._html += "</span>"

if __name__ == '__main__':
    high = Highlighter(sys.argv[1] if len(sys.argv) > 1 else "src/ixml.ixml")
    high.highlight()

    if len(sys.argv) > 2:
        with open(sys.argv[2], "w", encoding="utf-8") as xml:
            xml.write(high.html())
    else:
        print(high.html())
