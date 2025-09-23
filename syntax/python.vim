" Based on runtime/syntax/python.vim 2025-09-23.
" Only comment and string stuff are taken.
" For indent/python.vim

if !(has('nvim') && exists('b:ts_highlight'))
    finish
endif

" quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell

" Triple-quoted strings can contain doctests.
syn region  pythonString matchgroup=pythonQuotes
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,pythonUnicodeEscape,@Spell
syn region  pythonString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=\z('''\|"""\)+ skip=+\\["']+ end="\z1" keepend
      \ contains=pythonEscape,pythonUnicodeEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawString matchgroup=pythonQuotes
      \ start=+[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString matchgroup=pythonTripleQuotes
      \ start=+[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

" Formatted string literals (f-strings)
" https://docs.python.org/3/reference/lexical_analysis.html#f-strings
syn region  pythonFString
      \ matchgroup=pythonQuotes
      \ start=+\cF\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonFStringField,pythonFStringSkip,pythonEscape,pythonUnicodeEscape,@Spell
syn region  pythonFString
      \ matchgroup=pythonTripleQuotes
      \ start=+\cF\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonFStringField,pythonFStringSkip,pythonEscape,pythonUnicodeEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawFString
      \ matchgroup=pythonQuotes
      \ start=+\c\%(FR\|RF\)\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonFStringField,pythonFStringSkip,@Spell
syn region  pythonRawFString
      \ matchgroup=pythonTripleQuotes
      \ start=+\c\%(FR\|RF\)\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonFStringField,pythonFStringSkip,pythonSpaceError,pythonDoctest,@Spell

" Bytes
syn region  pythonBytes
      \ matchgroup=pythonQuotes
      \ start=+\cB\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonEscape
syn region  pythonBytes
      \ matchgroup=pythonTripleQuotes
      \ start=+\cB\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonEscape
syn region  pythonRawBytes
      \ matchgroup=pythonQuotes
      \ start=+\c\%(BR\|RB\)\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
syn region  pythonRawBytes
      \ matchgroup=pythonTripleQuotes
      \ start=+\c\%(BR\|RB\)\z('''\|"""\)+
      \ end="\z1"
      \ keepend

" Sync at the beginning of (async) function or class definitions.
syn sync match pythonSync grouphere NONE "^\%(def\|class\|async\s\+def\)\s\+\h\w*\s*[(:]"

let b:current_syntax = "python"
