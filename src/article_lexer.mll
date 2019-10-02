{
  open Article_parser

  exception SyntaxError of string

  let h_add k e t = Hashtbl.add t k e ; t

  let keywords_table =
    Hashtbl.create 19
    |> h_add "title"    TITLE
    |> h_add "authors"  AUTHORS
    |> h_add "date"     DATE
    |> h_add "default"  DEFAULT
    |> h_add "language" LANGUAGE
    |> h_add "updated"  UPDATED

}

let newline = ('\013' * '\010')

let blank = [' ' '\009' '\012']

rule token = parse
  | blank +
    { token lexbuf }
  | newline
    { Lexing.new_line lexbuf ; token lexbuf }
  | eof
    { EOF }
  | '"' { QSTRING (read_string (Buffer.create 13) lexbuf) }
  | ':'  { COLON }
  | '/' { SLASH }
  | ',' { COMMA }
  | "--" '-'+ newline { Lexing.new_line lexbuf ; CONTENT (read_content (Buffer.create 100) lexbuf) }
  | ['0'-'9']+ as i { INT (int_of_string i) }
  | [^ '\\' '\n' ':' '(' ' ' '\009' '\012' '"' '/' ','] + as id
    {
      try Hashtbl.find keywords_table id
      with Not_found -> STRING id
    }
  | _  { raise (SyntaxError ("Syntax Error, unknown char.")) }

and read_string buf = parse
  | [^ '"' '\n' '\\']+ as s { Buffer.add_string buf s ; read_string buf lexbuf }
  | '\\' '"' { Buffer.add_char buf '"' ; read_string buf lexbuf }
  | '\\' { Buffer.add_char buf '\\' ; read_string buf lexbuf }
  | '"' { Buffer.contents buf }
  | '\n'
    { Lexing.new_line lexbuf ;
      Buffer.add_char buf '\n' ;
      read_string buf lexbuf }
  | eof { raise (SyntaxError "String not terminated") }
  | _ { raise (SyntaxError "Don't know how to handle") }

and read_content buf = parse
  | [^ '\n']+ as s
    { Buffer.add_string buf s ; read_content buf lexbuf }
  | '\n'
    { Lexing.new_line lexbuf ;
      Buffer.add_char buf '\n' ;
      read_content buf lexbuf }
  | eof { Buffer.contents buf }
  | _ { assert false }
