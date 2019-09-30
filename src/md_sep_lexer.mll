{
  open Markdown_ast
  open Md_sep_parser

  let nl lexbuf = Lexing.new_line lexbuf

  let rec nnl n lexbuf =
    if n < 1 then ()
    else nl lexbuf ; nnl (n - 1) lexbuf

  exception SyntaxError of string
}

let newline = ('\013' * '\010')

(* Leading whitespace *)
let lws = ' '? | "  " | "   "

(* let str = ['0'-'9' 'a'-'z' 'A'-'Z' '/' '@' '.']+ *)
let str = [^ '[' ']' '"']+

rule token = parse
  | newline { nl lexbuf ; NL }
  | eof { EOF }
  | "    " [^ '\n']+ as s newline { nl lexbuf ; QUOTE s }
  | lws "```" { CODE (begin_codeblock (Buffer.create 13) lexbuf) }
  | lws "###### " [^ '\n']+ as s newline { nl lexbuf ; H (H6, s) }
  | lws "##### " [^ '\n']+ as s newline { nl lexbuf ; H (H5, s) }
  | lws "#### " [^ '\n']+ as s newline { nl lexbuf ; H (H4, s) }
  | lws "### " [^ '\n']+ as s newline { nl lexbuf ; H (H3, s) }
  | lws "## " [^ '\n']+ as s newline { nl lexbuf ; H (H2, s) }
  | lws "# " [^ '\n']+ as s newline { nl lexbuf ; H (H1, s) }
  | lws as ws ['0'-'9']+ as i ". "
    { OL (int_of_string i, begin_ol ws (Buffer.create 13) lexbuf) }
  | lws as ws ['-' '*'] ' ' { UL (begin_ul (Buffer.create 13) lexbuf) }
  | lws '[' str as r "]: " str as uri '"' str as s '"' newline
    { nl lexbuf ; REF (r, uri, Some s) }
  | lws '[' str as r "]: " str as uri newline
    { nl lexbuf ; REF (r, uri, None) }
  | [^ '\n']+ as s
    { let buf = Buffer.create 13 in Buffer.add_string buf s ; P (paragraph buf) }
  | _ { assert false }

and begin_codeblock lang = parse
  | newline
    { nl lexbuf ; (Buffer.contents lang, codeblock (Buffer.create 100) lexbuf) }
  | [^ '`' '\n']+ as st
    { Buffer.add_string lang st ; begin_codeblock lang lexbuf }
  | _ { raise (SyntaxError ("Expected language name or endline.")) }

and codeblock buf = parse
  | newline "```"
    { Buffer.contents buf }
  | '`'
    { Buffer.add_char buf '`' ; codeblock buf lexbuf }
  | newline
    { nl lexbuf ; Buffer.add_char buf '\n' ; codeblock buf lexbuf }
  | [^ '`' '\r' '\n']+ as st
    { Buffer.add_string buf st ; codeblock buf lexbuf }
  | eof
    { raise (SyntaxError ("Code not terminated.")) }
  | _
    { raise (SyntaxError ("Syntax Error, unknown char.")) }

and paragraph buf = parse
  | newline newline+ as l
    { nnl (1 + String.length l) lexbuf ;
      Buffer.add_char buf '\n' ;
      Buffer.add_string buf l ;
      Buffer.contents buf }
  | newline { nl lexbuf ; Buffer.add_char buf '\n' ; paragraph buf lexbuf }
  | [^ '\n']+ as s { Buffer.add_string buf s ; paragraph buf lexbuf }
  | _ { assert false }

(* TODO *)
and begin_ol ws buf = parse
  | newline { nl lexbuf ; Buffer.contents buf }
  | [^ '\n']+ as s { Buffer.add_string buf s ; begin_ol ws buf lexbuf }

(* TODO *)
and begin_ul ws buf = parse
  | newline { nl lexbuf ; Buffer.contents buf }
  | [^ '\n']+ as s { Buffer.add_string buf s ; begin_ol ws buf lexbuf }
