{
  open Markdown_parser

  exception SyntaxError of string
}

let newline = ('\013' * '\010')

(* Only newline *)
rule token = parse
  | newline { Lexing.new_line lexbuf ; NL }
  | eof { EOF }
  | "```" { CODEBLOCK (begin_codeblock (Buffer.create 13) lexbuf) }
  | "###### " { HD6 (header (Buffer.create 13) lexbuf) }
  | "##### " { HD5 (header (Buffer.create 13) lexbuf) }
  | "#### " { HD4 (header (Buffer.create 13) lexbuf) }
  | "### " { HD3 (header (Buffer.create 13) lexbuf) }
  | "## " { HD2 (header (Buffer.create 13) lexbuf) }
  | "# " { HD1 (header (Buffer.create 13) lexbuf) }
  | _ { line lexbuf }

and line = parse
  | newline { Lexing.new_line lexbuf ; NL }
  | eof { EOF }
  | '`' { INLINECODE (inlinecode (Buffer.create 13) lexbuf) }
  | '[' { SQBL }
  | ']' { SQBR }
  | '~' { TILDA }
  | '_' { UNDERSCORE }
  | '*' { STAR }
  | '!' { BANG }
  | ':' { COLON }
  | '"' { QUOTE }
  | [^ '\n' '[' ']' '~' '_' '*' '!' '`' ':' '"']+ as text { STRING text }
  | _ { raise (SyntaxError ("Syntax Error, unknown char.")) }

and header buf = parse
  | newline
    { Lexing.new_line lexbuf ; Buffer.contents buf }
  | [^ '\r' '\n']+ as st
    { Buffer.add_string buf st ; header buf lexbuf }
  | _ { raise (SyntaxError "Unknown char (or EOF, TODO).") }

and begin_codeblock lang = parse
  | newline
    { Lexing.new_line lexbuf ; (Buffer.contents lang, codeblock (Buffer.create 100) lexbuf) }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string lang st ; begin_codeblock lang lexbuf }
  | _ { raise (SyntaxError ("Expected language name or endline.")) }

and codeblock buf = parse
  | newline "```"
    { Buffer.contents buf }
  | '`'
    { Buffer.add_char buf '`' ; codeblock buf lexbuf }
  | newline
    { Lexing.new_line lexbuf ; Buffer.add_char buf '\n' ; codeblock buf lexbuf }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string buf st ; codeblock buf lexbuf }
  | eof
    { raise (SyntaxError ("Code not terminated.")) }
  | _
    { raise (SyntaxError ("Syntax Error, unknown char.")) }

and inlinecode buf = parse
  | '`'
    { Buffer.contents buf }
  | newline
    { Lexing.new_line lexbuf ; Buffer.add_char buf '\n' ; inlinecode buf lexbuf }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string buf st ; inlinecode buf lexbuf }
  | eof
    { raise (SyntaxError ("Code not terminated.")) }
  | _
    { raise (SyntaxError ("Syntax Error, unknown char.")) }
