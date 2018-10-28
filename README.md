## Lexing
Ruby doesn’t use Lex, which is usually used together with something like Yacc or Bison.  Ruby core team opted to write custom tokenization code by hand. [`parser_yylex`](https://github.com/ruby/ruby/blob/v2_5_3/parse.y#L8261) in `parse.y` is responsible for tokenizing source code of the ruby script.

#### Reserved keywords
Reserved keywords are defined in [`defs/keywords`](https://github.com/ruby/ruby/blob/v2_5_3/defs/keywords). This file is run through gperf.  Produced C code that can quickly look up reserved keywords lives in lex.c.  The `rb_reserved_word` is called from `parse.y`.

## Example 1
{% gist 8e048a43f4e5e42fc5778b8f64062513 lexing_example_1.rb %}

This simple code is tokenized to:
```
=> [[[1, 0], :on_int, "5"],
 [[1, 1], :on_period, "."],
 [[1, 2], :on_ident, "times"],
 [[1, 7], :on_sp, " "],
 [[1, 8], :on_kw, "do"],
 [[1, 10], :on_sp, " "],
 [[1, 11], :on_op, "|"],
 [[1, 12], :on_ident, "n"],
 [[1, 13], :on_op, "|"],
 [[1, 14], :on_ignored_nl, "\n"],
 [[2, 0], :on_sp, "  "],
 [[2, 2], :on_ident, "puts"],
 [[2, 6], :on_sp, " "],
 [[2, 7], :on_ident, "n"],
 [[2, 8], :on_nl, "\n"],
 [[3, 0], :on_kw, "end"],
 [[3, 3], :on_nl, "\n"]]
```
We get a collection of tokens.  Each token consists of [line, column], a token identifier (which is actually different from what C code sees here), and characters that make up the token. 
