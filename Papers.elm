module Papers exposing (..)

import Profiles exposing (..)
import Json.Decode as Decode

-- Publications
-- We need to compute the right url
format_name : Profile -> String
format_name p =
  p.firstname ++ "%2C" ++ p.lastname

format_names : String
format_names =
  case profiles ++ oldprofiles of
    h :: t ->
      List.foldl (\ p s -> s ++ "%3B" ++ (format_name p)) (format_name h) t
    [] -> ""

hal_url : String
hal_url =
  "https://haltools.archives-ouvertes.fr/Public/afficheRequetePubli.php?auteur_exp=" ++
  format_names ++
  "&struct=Gallinette&CB_auteur=oui&CB_titre=oui&CB_article=oui&CB_typdoc=oui&langue=Anglais&tri_exp=annee_publi&tri_exp2=typdoc&tri_exp3=date_publi&ordre_aff=TA&Fen=Aff&css=../css/VisuRubriqueEncadre.css"

-- Copy of the JSON representation of paper returned by HAL
type alias Paper = {
  uri_s             : String,
  authFullName_s    : List String,
  title_s           : List String,
  releasedDateY_i   : Int,
  file_s            : Maybe (List String),
  conferenceTitle_s : Maybe String,
  journalTitle_s    : Maybe String
}

-- HTTP

paperUrl : Bool -> String
paperUrl oldpapers =
  -- Publications in JSON
  -- We create the URL from the profiles
  let
    url_name : Profile -> String
    url_name p =
      "\"" ++ p.firstname ++ "%20" ++ p.lastname ++ "\""

    list : List Profile
    list =
      if oldpapers
        then profiles ++ oldprofiles
        else profiles

    url_names : String
    url_names =
      case list of
        h :: t ->
          List.foldl
            (\ p s -> s ++ "%20OR%20" ++ (url_name p))
            ("(" ++ (url_name h)) t ++ ")"
        [] -> ""

    url : String
    url =
      "https://api.archives-ouvertes.fr/search/?wt=json&q=authFullName_s:" ++
      url_names ++
      -- "&fq=rteamStructAcronym_s:(ASCOLA%20OR%20GALLINETTE)" ++
      "&fq=rteamStructAcronym_s:(GALLINETTE)" ++
      "&fl=docid,uri_s,label_s,authFullName_s,title_s,releasedDateY_i,files_s,conferenceTitle_s,journalTitle_s" ++
      "&sort=docid%20desc"
  in url

-- Takes the JSON of a paper and returns a paper
decodePaper : Decode.Decoder Paper
decodePaper =
  Decode.map7
    Paper
    (Decode.field "uri_s" Decode.string)
    (Decode.field "authFullName_s" (Decode.list Decode.string))
    (Decode.field "title_s" (Decode.list Decode.string))
    (Decode.field "releasedDateY_i" Decode.int)
    (Decode.maybe (Decode.field "files_s" (Decode.list Decode.string)))
    (Decode.maybe (Decode.field "conferenceTitle_s" Decode.string))
    (Decode.maybe (Decode.field "journalTitle_s" Decode.string))

-- Takes the JSON and returns a list of Papers
decodePapers : Decode.Decoder (List Paper)
decodePapers =
  Decode.at ["response","docs"] (Decode.list decodePaper)
