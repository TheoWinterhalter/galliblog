type status =
| PhDStudent
| Permanent
| ResearchEngineer
| PostDoc
| Other of string

type person = {
  firstname : string ;
  lastname : string ;
  status : status ;
  pic : string option ;
  page : string option
}

let mk firstname lastname status pic page = {
  firstname ; lastname ; status ; pic ; page
}

let simon =
  mk "Simon" "Boulier" ResearchEngineer (Some "fantomas.jpg")
     (Some "http://perso.eleves.ens-rennes.fr/people/Simon.Boulier/")

let theo =
    mk "Théo" "Winterhalter" PhDStudent (Some "theo.jpg")
       (Some "https://theowinterhalter.github.io/")

let xavier = mk "Xavier" "Montillet" PhDStudent (Some "xavier.jpg") None

let ambroise =
  mk "Ambroise" "Lafont" PhDStudent (Some "ambroise.jpg")
     (Some "https://amblafont.github.io/")

let gaetan = mk "Gaëtan" "Gilbert" PhDStudent None None

let igor = mk "Igor" "Zhirkov" PhDStudent (Some "igor.jpg") None

let meven = mk "Meven" "Bertrand" PhDStudent (Some "meven.jpg") None

let loic = mk "Loïc" "Pujet" PhDStudent None None

let eric =
  mk "Eric" "Finster" PostDoc (Some "eric.jpg")
     (Some "http://ericfinster.github.io/")

let etienne =
  mk "Étienne" "Miquey" PostDoc (Some "miquey.jpg")
     (Some "https://www.irif.fr/~emiquey/")

let pierre =
  mk "Pierre" "Vial" PostDoc (Some "vial.jpg")
     (Some "https://www.irif.fr/~pvial/")

let marie =
  mk "Marie" "Kerjean" PostDoc (Some "marie.jpg")
     (Some "https://www.irif.fr/~kerjean/")

let maxime =
  mk "Maxime" "Lucas" PostDoc None
     (Some "http://lucas-webpage.gforge.inria.fr/")

let julien =
  mk "Julien" "Cohen" Permanent (Some "julien-cohen.png")
     (Some "http://pagesperso.lina.univ-nantes.fr/info/perso/permanents/cohen/")

let assia =
  mk "Assia" "Mahboubi" Permanent (Some "assia.jpg")
     (Some "https://specfun.inria.fr/mahboubi/")

let guillaume =
  mk "Guillaume" "Munch-Maccagnoni" Permanent (Some "guillaume.jpg")
     (Some "http://guillaume.munch.name/")

let herve =
  mk "Hervé" "Graal" Permanent (Some "herve.png") None

let remi =
  mk "Rémi" "Douence" Permanent (Some "remi.png") None

let nicolas =
  mk "Nicolas" "Tabareau" Permanent (Some "portrait_2014_small_square.jpg")
     (Some "http://tabareau.fr/")

let pm =
  mk "Pierre-Marie" "Pédrot" Permanent (Some "pm.jpg")
     (Some "https://www.pédrot.fr/")

let guilhem =
  mk "Guilhem" "Jaber" Permanent (Some "guilhem.jpg")
     (Some "http://guilhem.jaber.fr/")

let members = [
  simon ;
  theo ;
  xavier ;
  ambroise ;
  gaetan ;
  igor ;
  meven ;
  loic ;
  eric ;
  etienne ;
  pierre ;
  marie ;
  maxime ;
  julien ;
  assia ;
  guillaume ;
  herve ;
  remi ;
  nicolas ;
  pm ;
  guilhem
]

let kevin =
  mk "Kevin" "Quirin" (Other "Mathematics Teacher") (Some "Quirin.jpg")
     (Some "http://kevin.quirin.free.fr/")

let ben =
  mk "Benedikt" "Arhens" (Other "Bigmingham Fellow") (Some "benedikt.png")
     (Some "http://benedikt-ahrens.de/")

let danil =
  mk "Danil" "Annenkov" (Other "Post-Doc in Aarhus") (Some "danil.png") None

let past_members = [
  kevin ;
  ben ;
  danil
]
