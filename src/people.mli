(** People of the team *)

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

val members : person list
val past_members : person list
