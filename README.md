## Lexing
Ruby doesn’t use Lex, which is usually used together with something like Yacc or Bison.  Ruby core team opted to write custom tokenization code by hand. [`parser_yylex`](https://github.com/ruby/ruby/blob/v2_5_3/parse.y#L8261) in `parse.y` is responsible for tokenizing source code of the ruby script.

#### Reserved keywords
Reserved keywords are defined in [`defs/keywords`](https://github.com/ruby/ruby/blob/v2_5_3/defs/keywords). This file is run through gperf.  Produced C code that can quickly look up reserved keywords lives in lex.c.  The `rb_reserved_word` is called from `parse.y`.

### Example 1
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

### Example 2

{% gist 8e048a43f4e5e42fc5778b8f64062513 lexing_example_2.rb %}

```
=> [[[1, 0], :on_ident, "array"],
 [[1, 5], :on_sp, " "],
 [[1, 6], :on_op, "="],
 [[1, 7], :on_sp, " "],
 [[1, 8], :on_lbracket, "["],
 [[1, 9], :on_rbracket, "]"],
 [[1, 10], :on_nl, "\n"],
 [[2, 0], :on_int, "5"],
 [[2, 1], :on_period, "."],
 [[2, 2], :on_ident, "times"],
 [[2, 7], :on_sp, " "],
 [[2, 8], :on_kw, "do"],
 [[2, 10], :on_sp, " "],
 [[2, 11], :on_op, "|"],
 [[2, 12], :on_ident, "x"],
 [[2, 13], :on_op, "|"],
 [[2, 14], :on_ignored_nl, "\n"],
 [[3, 0], :on_sp, "  "],
 [[3, 2], :on_ident, "array"],
 [[3, 7], :on_sp, " "],
 [[3, 8], :on_op, "<<"],
 [[3, 10], :on_sp, " "],
 [[3, 11], :on_ident, "x"],
 [[3, 12], :on_sp, " "],
 [[3, 13], :on_kw, "if"],
 [[3, 15], :on_sp, " "],
 [[3, 16], :on_ident, "x"],
 [[3, 17], :on_sp, " "],
 [[3, 18], :on_op, "<"],
 [[3, 19], :on_sp, " "],
 [[3, 20], :on_int, "5"],
 [[3, 21], :on_nl, "\n"],
 [[4, 0], :on_kw, "end"],
 [[4, 3], :on_nl, "\n"],
 [[5, 0], :on_ident, "p"],
 [[5, 1], :on_sp, " "],
 [[5, 2], :on_ident, "array"],
 [[5, 7], :on_nl, "\n"]]
```
One thing to note in this example, is that the tokenizer can correctly distinguish `<` from `<<`. 

### Example 3

All the tokenizer does, is parse tokens.  It can not tell whether the syntax is correct.

{% gist 8e048a43f4e5e42fc5778b8f64062513 lexing_example_3.rb %}

In this example, there is an obvious syntax error.  Tokekenizer will hover still tokenize the file correctly. 

```
╰─$ ruby lexing_example_3.rb
5.times do |x
  puts x
end
[[[1, 0], :on_int, "5"],
 [[1, 1], :on_period, "."],
 [[1, 2], :on_ident, "times"],
 [[1, 7], :on_sp, " "],
 [[1, 8], :on_kw, "do"],
 [[1, 10], :on_sp, " "],
 [[1, 11], :on_op, "|"],
 [[1, 12], :on_ident, "x"],
 [[1, 13], :on_nl, "\n"],
 [[2, 0], :on_sp, "  "],
 [[2, 2], :on_ident, "puts"],
 [[2, 6], :on_sp, " "],
 [[2, 7], :on_ident, "x"],
 [[2, 8], :on_nl, "\n"],
 [[3, 0], :on_kw, "end"]]
 ```
