open Lexing
open Article_ast

type part = {
  title : string option ;
  authors : string list option ;
  date : (int * int * int) option ;
  content : Html.t list
}

type t = {
  _title : string ;
  _authors : string list ;
  _date : int * int * int ;
  _content : Html.t list
}

exception Error of string

let error fmt = Printf.ksprintf (fun s -> raise (Error s)) fmt

let print_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  let str = Lexing.lexeme lexbuf in
  let begchar = pos.pos_cnum - pos.pos_bol + 1 in
  Printf.sprintf "In %s, line %d, characters %d-%d : %s"
    pos.pos_fname pos.pos_lnum begchar
    (begchar + (String.length str))
    (Lexing.lexeme lexbuf)

let parse_with_errors lexbuf =
  try
    Article_parser.file Article_lexer.token lexbuf
  with
  | Article_lexer.SyntaxError msg ->
    error "%s : %s (lexing error)" (print_position lexbuf) msg
  | Article_parser.Error ->
    error "%s : Syntax Error" (print_position lexbuf)

let check c =
  if c.title = None then error "Field 'title' mandatory" ;
  if c.authors = None then error "Field 'authors' mandatory" ;
  if c.date = None then error "Field 'date' mandatory" ;
  begin match c with
  | { title = Some _title ;
      authors = Some _authors ;
      date = Some _date ;
      content = _content
    } ->
    { _title ; _authors ; _date ; _content }
  | _ -> assert false
  end

let with_title c title =
  match c.title with
  | None -> { c with title = Some title }
  | Some _ -> error "Cannot set 'title' twice"

let with_authors c authors =
  match c.authors with
  | None -> { c with authors = Some authors }
  | Some _ -> error "Cannot set 'authors' twice"

let with_date c date =
  match c.date with
  | None -> { c with date = Some date }
  | Some _ -> error "Cannot set 'date' twice"

let rec from_ast c ast =
  match ast with
  | Title title :: ast -> from_ast (with_title c title) ast
  | Authors l :: ast -> from_ast (with_authors c l) ast
  | Date (d,m,y) :: ast -> from_ast (with_date c (d,m,y)) ast
  | [] -> check c

let from_file f =
  let input = open_in f in
  let lexbuf = from_channel input in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = f } ;
  (* By parsing the content later, we are able to use information from
     the header to choose which parser.
     It also allows us to deal with content taken from a different source
     than the file itself.
   *)
  let (ast, content) = parse_with_errors lexbuf in
  close_in input ;
  let content = Omd.of_string content in
  let content = Markdown.md_to_html content in
  let default = {
    title = None ;
    authors = None ;
    date = None ;
    content
  } in
  from_ast default ast

let title a = a._title

let authors a = a._authors

let date a = a._date

let content a = a._content
