module OptionMonad = struct

  let (>>=) opt f =
    match opt with
    | Some x -> f x
    | None -> None

  let (>>>=) opt f =
    match opt with
    | Some x -> Some (f x)
    | None -> None

  let return x = Some x

end

let rec list_cat_sep sep l =
  match l with
  | [] -> []
  | [ e ] -> [ e ]
  | e :: l -> e :: sep :: list_cat_sep sep l

(** Date [d/m/y] *)
type date = int * int * int

let month = function
  | 1 -> "January"
  | 2 -> "February"
  | 3 -> "March"
  | 4 -> "April"
  | 5 -> "May"
  | 6 -> "June"
  | 7 -> "July"
  | 8 -> "August"
  | 9 -> "September"
  | 10 -> "October"
  | 11 -> "November"
  | 12 -> "December"
  | _ -> "???"
