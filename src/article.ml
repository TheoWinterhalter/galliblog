open Lexing
open Article_ast

type part = {
  title : string option ;
  authors : string list option ;
  date : (int * int * int) option ;
  default_language : string option
}

type header = {
  _title : string ;
  _authors : string list ;
  _date : int * int * int ;
  _default_language : string option
}

type t = {
  header : header ;
  content : Html.t list
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
      default_language = _default_language
    } ->
    { _title ; _authors ; _date ; _default_language }
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

let with_default_language c l =
  match c.default_language with
  | None -> { c with default_language = Some l }
  | Some _ -> error "Cannot set 'default language' twice"

let rec from_ast c ast =
  match ast with
  | Title title :: ast -> from_ast (with_title c title) ast
  | Authors l :: ast -> from_ast (with_authors c l) ast
  | Date (d,m,y) :: ast -> from_ast (with_date c (d,m,y)) ast
  | Default_language s :: ast -> from_ast (with_default_language c s) ast
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
  let default = {
    title = None ;
    authors = None ;
    date = None ;
    default_language = None
  } in
  let header = from_ast default ast in
  let content = Omd.of_string content in
  (* If default language is set then we apply it *)
  let content =
    begin match header._default_language with
    | Some lang -> Omd.set_default_lang lang content
    | None -> content
    end
  in
  let content = Markdown.md_to_html content in
  { header ; content }

let title a = a.header._title

let authors a = a.header._authors

let date a = a.header._date

let default_language a = a.header._default_language

let content a = a.content
