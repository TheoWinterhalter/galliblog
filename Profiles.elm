module Profiles exposing (..)

type alias Profile = {
  firstname : String,
  lastname  : String
}

profiles : List Profile
profiles =
  [ Profile "Simon" "Boulier",
    Profile "Théo" "Winterhalter",
    Profile "Xavier" "Montillet",
    Profile "Ambroise" "Lafont",
    Profile "Gaëtan" "Gilbert",
    Profile "Igor" "Zhirkov",
    Profile "Meven" "Bertrand",
    Profile "Loïc" "Pujet",
    Profile "Eric" "Finster",
    Profile "Étienne" "Miquey",
    Profile "Pierre" "Vial",
    Profile "Marie" "Kerjean",
    Profile "Maxime" "Lucas",
    Profile "Julien" "Cohen",
    Profile "Guillaume" "Munch-Maccagnoni",
    Profile "Hervé" "Graal",
    Profile "Rémi" "Douence",
    Profile "Assia" "Mahboubi",
    Profile "Pierre-Marie" "Pédrot",
    Profile "Guilhem" "Jaber",
    Profile "Nicolas" "Tabareau" ]

oldprofiles : List Profile
oldprofiles =
  [ Profile "Kevin" "Quirin",
    Profile "Danil" "Annenkov",
    Profile "Benedikt" "Ahrens" ]
