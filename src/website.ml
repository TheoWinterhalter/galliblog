open Util
open Attribute
open Html
open Html_util

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
    body [] [
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
        ] ;
        nav [] [
          a [ href "index.html" ] [ text "Presentation" ] ;
          a [ href "members.html" ] [ text "Members" ] ;
          a [ href "papers.html" ] [ text "Publications" ] ;
          a [ href "blog/index.html" ] [ text "Blog" ]
        ]
      ] ;
      main [] page
    ]
  ]

(* let _index = [
  section [] [
    p [] [
      text "Gallinette is a joint team of " ;
      lnk "http://www.inria.fr/en/" "Inria" ;
      text " and of the " ;
      lnk "http://www.ls2n.fr/?lang=en" "Laboratory of Digital
      Science of Nantes (LS2N)" ;
      text ", co-located at " ;

    ]
  ]
] *)

let _index =
  let file = open_in "content/index.html" in
  let s = really_input_string file (in_channel_length file) in
  close_in file ;
  [ text s ]

let index = template _index

let member p =
  let pic =
    match p.People.pic with
    | Some p -> p
    | None -> "na.png"
  in
  let name = p.People.firstname ^ " " ^ p.People.lastname in
  let name =
    match p.People.page with
    | Some p -> lnk p name
    | None -> text name
  in
  let status =
    match p.People.status with
    | PhDStudent -> "PhD Student"
    | Permanent -> "Permanent researcher"
    | ResearchEngineer -> "Research Engineer"
    | PostDoc -> "Post-Doc"
    | Other s -> s
  in
  li [] [
    img [ src ("img/profiles/" ^ pic) ] ;
    span [ classes [ "name" ] ] [ name ] ;
    span [ classes [ "status" ] ] [ text status ]
  ]

let _members = [
  section [] [
    h3 [] [ text "Members" ] ;
    ul [ classes [ "portrait" ] ] (List.map member People.members)
  ] ;
  section [] [
    h3 [] [ text "Past members" ] ;
    ul [ classes [ "portrait" ] ] (List.map member People.past_members)
  ]
]

let members = template _members

let _papers =
  let file = open_in "content/papers.html" in
  let s = really_input_string file (in_channel_length file) in
  close_in file ;
  [ text s ]

let papers = html [] _papers
