## Lexing
Ruby doesn’t use Lex, which is usually used together with something like Yacc or Bison.  Ruby core team opted to write custom tokenization code by hand. [`parser_yylex`](https://github.com/ruby/ruby/blob/v2_5_3/parse.y#L8261) in `parse.y` is responsible for tokenizing source code of the ruby script.

#### Reserved keywords
Reserved keywords are defined in [`defs/keywords`](https://github.com/ruby/ruby/blob/v2_5_3/defs/keywords). This file is run through gperf.  Produced C code that can quickly look up reserved keywords lives in lex.c.  The `rb_reserved_word` is called from `parse.y`.

## Example 1
{ gist 8e048a43f4e5e42fc5778b8f64062513 }
