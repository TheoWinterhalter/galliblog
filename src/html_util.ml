open Util
open Attribute
open Html

let authors_html l =
  l
  |> List.map (fun a -> span [ classes [ "author" ] ] [ text a ])
  |> list_cat_sep (text " and ")
  |> fun l -> text "By " :: l @ [ text "." ]

let blog_header ~index =
  let root =
    if index then "" else "../"
  in
  header [ classes [ "main" ] ] [
    a [ href (root ^ "index.html") ] [
      h1 [] [ text "Galliblog" ]
    ] ;
    h2 [] [
      text "The " ;
      a [ href (root ^ "../index.html") ] [
        text "Gallinette"
      ] ;
      text " blog"
    ]
  ]

let tags_html tags =
  ul [ classes [ "tags" ] ] (List.map (fun t -> li [] [ text t ]) tags)
