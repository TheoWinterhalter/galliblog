{
  open Article_parser

  exception SyntaxError of string

  let h_add k e t = Hashtbl.add t k e ; t

  let keywords_table =
    Hashtbl.create 19
    |> h_add "title"   TITLE
    |> h_add "authors" AUTHORS
    |> h_add "date"    DATE

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
  | "\"" { STRING (read_string (Buffer.create 13) lexbuf) }
  | ":"  { COLON }
  | "/" { SLASH }
  | "," { COMMA }
  | "--" "-"+ newline { CONTENT (read_content (Buffer.create 13) lexbuf) }
  | ['0'-'9']+ { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | [^ '\\' '\n' ':' '(' ' ' '\009' '\012'] +
    {
      try Hashtbl.find keywords_table (Lexing.lexeme lexbuf)
      with Not_found -> STRING (Lexing.lexeme lexbuf)
    }
  | _  {raise (SyntaxError ("Syntax Error, unknown char."))}

and read_string buf = parse
  | "\\\"" { Buffer.add_char buf '"' ; read_string buf lexbuf }
  | "\"" { Buffer.contents buf }
  | newline { Lexing.new_line lexbuf ;
              Buffer.add_char buf '\n' ;
              read_string buf lexbuf }
  | [^ '"' '\r' '\n']+
    {
      Buffer.add_string buf (Lexing.lexeme lexbuf) ;
      read_string buf lexbuf
    }
  | eof { raise (SyntaxError "String not terminated") }
  | _ { assert false }

and read_content buf = parse
  | _* { Buffer.add_string buf (Lexing.lexeme lexbuf) ; read_content buf lexbuf }
  | eof { Buffer.contents buf }
  | _ { assert false }
