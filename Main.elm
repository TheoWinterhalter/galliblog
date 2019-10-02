module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http

import Papers exposing (..)

main : Program Never Model Msg
main =
  Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }


-- MODEL

type alias Model = {
  papers    : List Paper,
  paper_err : Maybe String,
  oldpapers : Bool
}


-- INIT

init : (Model, Cmd Msg)
init =
  let model = Model [] Nothing True in
  (model, getPapers model)


-- UPDATE

type Msg =
    NewPapers (Result Http.Error (List Paper))
  | ToggleOldpapers

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NewPapers (Ok papers) ->
      ({ model | papers = papers, paper_err = Nothing }, Cmd.none)

    NewPapers (Err msg) ->
      ({ model | paper_err = Just (toString msg) }, Cmd.none)

    ToggleOldpapers ->
      let newmodel = { model | oldpapers = not model.oldpapers } in
      (newmodel, getPapers newmodel)


-- VIEW

checkbox : Bool -> msg -> String -> Html msg
checkbox b msg name =
  label [] [
    input [ checked b, type_ "checkbox", onClick msg ] [],
    text name
  ]

-- TODO Take into account the type of the file
files_view : Maybe (List String) -> List (Html Msg)
files_view ml =
  case ml of
    Just l ->
      List.map (\ url -> a [ href url ] [ text "PDF" ]) l
    Nothing  -> []

paper_view : Paper -> Html Msg
paper_view paper =
  li [] [
    h4 [] [
      a [ href paper.uri_s ] [
        text (String.join ", " paper.title_s)
      ]
    ],
    p [] [
      text (
        (String.join ", " paper.authFullName_s) ++
        " (" ++ (toString paper.releasedDateY_i) ++ ")"
      )
    ],
    p [ class "conference" ] (
      case paper.conferenceTitle_s of
        Just name -> [ text name ]
        Nothing ->
          case paper.journalTitle_s of
            Just name -> [ text name ]
            Nothing -> []
    ),
    div [ class "files" ] (
      (files_view paper.file_s) ++
      [ a [ href (paper.uri_s ++ "/bibtex") ] [ text "Bibtex" ] ]
    )
  ]

view : Model -> Html Msg
view model =
  section [] [
    h3 [] [ text "Publications" ],
    h4 [] [
      text "Source: ",
      a [ href hal_url ] [ text "HAL" ],
      text "."
    ],
    p [] (
      if List.isEmpty model.papers
        then
          [ text "None found / error." ]
        else
          [
            text (
              "Showing " ++
              toString (List.length model.papers) ++
              " articles."
            )
          ]
    ),
    checkbox model.oldpapers ToggleOldpapers "Include papers from former members",
    case model.paper_err of
      Nothing -> text ""
      Just s -> text s,
    ul [ class "articles" ] (List.map paper_view model.papers)
  ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP

getPapers : Model -> Cmd Msg
getPapers model =
  Http.send NewPapers (Http.get (paperUrl model.oldpapers) decodePapers)
