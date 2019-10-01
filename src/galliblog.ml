open Util

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let copy src dest =
  let command = Printf.sprintf "cp %s %s" src dest in
  (* if not (Sys.file_exists dest) then *)
  Unix.system command |> ignore

let rec list_last_is x l =
  begin match l with
  | [] -> false
  | [ y ] -> x = y
  | e :: l -> list_last_is x l
  end

let ismd file =
  String.split_on_char '.' file
  |> list_last_is "md"

let rec list_beginning l =
  begin match l with
  | [] -> []
  | [ x ] -> []
  | e :: l -> e :: list_beginning l
  end

let name file =
  String.split_on_char '.' file
  |> list_beginning
  |> String.concat "."

let make_article file =
  let entry = Article.from_file ("content/articles/" ^ file) in
  let output = open_out ("website/" ^ (name file) ^ ".html") in
  let page = Article.page entry in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output ;
  entry

let () =
  fmkdir "website" ;
  copy "content/blog.css" "website/blog.css" ;
  let articles =
    Sys.readdir "content/articles"
    |> Array.to_list
    |> List.filter ismd
  in
  let articles =
    articles
    |> List.map (fun f -> (name f, make_article f))
  in
  ()
