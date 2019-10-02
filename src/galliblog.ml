open Util
open OptionMonad

let make_article file =
  let entry = Article.from_file ("content/articles/" ^ file) in
  let output = open_out ("website/article/" ^ (fname file) ^ ".html") in
  let page = Article.page entry in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output ;
  entry

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
  let open Html_util in
  let html_entry (na, f) =
    li [] (
      a [ href ("article/" ^ na ^ ".html") ] [
        h4 [] [ text (Article.title f) ]
      ] ::
      p [] (authors_html (Article.authors f)) ::
      p [] [ text (date_text (Article.date f) (Article.updated f))] ::
      (Article.tags f >>>= tags_html) -::
      []
    )
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
        blog_header ~index:true ;
        main [] [
          h3 [] [ text "List of articles" ] ;
          ul [ classes [ "articles" ] ] articles
        ]
      ]
    ]
  in
  let output = open_out ("website/index.html") in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
