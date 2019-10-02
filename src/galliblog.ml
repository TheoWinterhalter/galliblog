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

let fname file =
  String.split_on_char '.' file
  |> list_beginning
  |> String.concat "."

let make_article file =
  let entry = Article.from_file ("content/articles/" ^ file) in
  let output = open_out ("website/article/" ^ (fname file) ^ ".html") in
  let page = Article.page entry in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output ;
  entry

let compare_dates (d,m,y) (d',m',y') =
  compare (y,m,d) (y',m',d')

(* TODO Remove dupplication by having some Html utils *)
let authors_html l =
  let open Attribute in
  let open Html in
  l
  |> List.map (fun a -> span [ classes [ "author" ] ] [ text a ])
  |> list_cat_sep (text " and ")
  |> fun l -> text "By " :: l @ [ text "." ]

let date_text (d,m,y) updated =
  begin match updated with
  | Some (d',m',y') ->
    Printf.sprintf
      "On %d %s %d, last updated on %d %s %d." d (month m) y d' (month m') y'
  | None -> Printf.sprintf "On %d %s %d." d (month m) y
  end

let () =
  fmkdir "website" ;
  fmkdir "website/article" ;
  copy "content/blog.css" "website/blog.css" ;
  let articles =
    Sys.readdir "content/articles"
    |> Array.to_list
    |> List.filter ismd
  in
  (* Building the homepage *)
  (* TODO Later, do several pages. *)
  let open Attribute in
  let open Html in
  let html_entry (na, f) =
    li [] [
      a [ href ("article/" ^ na ^ ".html") ] [
        h3 [] [ text (Article.title f) ]
      ] ;
      p [] (authors_html (Article.authors f)) ;
      p [] [ text (date_text (Article.date f) (Article.updated f))]
    ]
  in
  let articles =
    articles
    |> List.map (fun f -> (fname f, make_article f))
    |> List.sort (fun (_,a) (_,b) -> compare_dates (Article.date b) (Article.date a))
    |> List.map html_entry
  in
  let page =
    html [] [
      head [] [
        title [] [ text ("Galliblog — List of articles") ] ;
        meta [ charset "utf-8" ] ;
        link [
          href "https://fonts.googleapis.com/css?family=Open+Sans:300,400,700" ;
          rel "stylesheet" ;
          typ "text/css"
        ] ;
        link [ rel "stylesheet" ; href ("blog.css") ] ;
      ] ;
      body [] [
        main [] [
          h1 [] [ text "Welcome to Galliblog" ] ;
          h2 [] [ text "List of articles" ] ;
          ul [] articles
        ]
      ]
    ]
  in
  let output = open_out ("website/index.html") in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
