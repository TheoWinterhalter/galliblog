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

let template page =
  html [] [
    head [] [
      meta [ charset "utf-8" ] ;
      title [] [ text "Gallinette" ] ;
      script [ typ "text/javascript" ; src "elm.js" ] [] ;
      link [
        href "https://fonts.googleapis.com/css?family=Open+Sans:300,400,700" ;
        typ "text/css" ;
        rel "stylesheet"
      ] ;
      link [ rel "stylesheet" ; href "normalize.css" ] ;
      link [ rel "stylesheet" ; href "style.css" ]
    ] ;
    body [] (
      header [] [
        h1 [] [ text "Gallinette" ] ;
        figure [] [
          a [ href "https://www.inria.fr/" ] [
            img [ src "img/logo-inria2.png" ; alt "logo inria" ]
          ] ;
          a [ href "https://ls2n.fr/" ] [
            img [ src "img/logo-ls2n.png" ; alt "logo LS2N" ]
          ] ;
          a [ href "https://www.imt-atlantique.fr/" ] [
            img [ src "img/logo-imta.png" ; alt "logo IMT Atlantique" ]
          ] ;
          a [ href "http://www.univ-nantes.fr/" ] [
            img [
              src "img/logo-univ-nantes.png" ;
              alt "logo Université de Nantes"
            ]
          ]
        ]
      ] ::
      nav [] [
        a [ href "index.html" ] [ text "Presentation" ] ;
        a [ href "members.html" ] [ text "Members" ] ;
        a [ href "papers.html" ] [ text "Publications" ]
      ] ::
      page
    )
  ]
