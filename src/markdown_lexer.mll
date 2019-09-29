{
  open Markdown_parser

  exception SyntaxError of string
}

let newline = ('\013' * '\010')

(* Only newline *)
rule token = parse
  | newline { Lexing.new_line lexbuf ; NL }
  | eof { EOF }
  | '[' { SQBL }
  | ']' { SQBR }
  | '~' { TILDA }
  | '_' { UNDERSCORE }
  | '*' { STAR }
  | '!' { BANG }
  | '#' { SHARP }
  | "```" { CODEBLOCK (begin_read_codeblock (Buffer.create 13) lexbuf) }
  | '`' { INLINECODE (read_inlinecode (Buffer.create 13) lexbuf) }
  | [^ '\n' '[' ']' '~' '_' '*' '!' '`']+ as text { STRING text }
  | _ { raise (SyntaxError ("Syntax Error, unknown char.")) }

and begin_read_codeblock lang = parse
  | newline
    { Lexing.new_line lexbuf ; (Buffer.contents lang, read_codeblock (Buffer.create 100) lexbuf) }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string lang st ; begin_read_codeblock lang lexbuf }
  | _ { raise (SyntaxError ("Expected language name or endline.")) }

and read_codeblock buf = parse
  | newline "```"
    { Buffer.contents buf }
  | '`'
    { Buffer.add_char '`' ; read_codeblock buf lexbuf }
  | newline
    { Lexing.new_line lexbuf ; Buffer.add_char buf '\n' ; read_codeblock buf lexbuf }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string buf st ; read_codeblock buf lexbuf }
  | eof
    { raise (SyntaxError ("Code not terminated.")) }
  | _
    { raise (SyntaxError ("Syntax Error, unknown char.")) }

and read_inlinecode buf = parse
  | '`'
    { Buffer.contents buf }
  | newline
    { Lexing.new_line lexbuf ; Buffer.add_char buf '\n' ; read_inlinecode buf lexbuf }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string buf st ; read_inlinecode buf lexbuf }
  | eof
    { raise (SyntaxError ("Code not terminated.")) }
  | _
    { raise (SyntaxError ("Syntax Error, unknown char.")) }
