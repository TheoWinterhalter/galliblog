open Util

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let copy src dest =
  let command = Printf.sprintf "cp %s %s" src dest in
  (* if not (Sys.file_exists dest) then *)
  Unix.system command |> ignore

let () =
  fmkdir "website" ;
  copy "content/blog.css" "website/blog.css" ;
  let entry = Article.from_file "content/articles/test.md" in
  let output = open_out "website/index.html" in
  let page = Article.page entry in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
