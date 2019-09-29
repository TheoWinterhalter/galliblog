open Lexing
open Markdown_ast

type t = Markdown_ast.t

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

let from_string s =
  let lexbuf = from_string s in
  try Markdown_parser.file Markdown_lexer.token lexbuf
  with
  | Markdown_lexer.SyntaxError msg ->
    error "%s : %s (lexing error)" (print_position lexbuf) msg
  | Markdown_parser.Error ->
    error "%s : Syntax Error" (print_position lexbuf)

let text_el_to_html el =
  begin match el with
  | Raw s -> Html.text s
  | _ -> Html.text "TODO"
  end

let text_to_html t =
  List.map text_el_to_html t

let el_to_html el =
  begin match el with
  | Paragraph t -> Html.p [] (text_to_html t)
  | Header (H1, t) -> Html.h1 [] (text_to_html t)
  | Header (H2, t) -> Html.h2 [] (text_to_html t)
  | _ -> Html.p [] [ Html.text "TODO" ]
  end

(* TODO Properly *)
let to_html md = List.map el_to_html md
