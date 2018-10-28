require 'ripper'
require 'pp'
code = <<STR
5.times do |n|
  puts n
end
STR
pp Ripper.lex(code)
