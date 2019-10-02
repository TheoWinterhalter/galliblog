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

let compare_dates (d,m,y) (d',m',y') =
  compare (y,m,d) (y',m',d')

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let copy src dest =
  let command = Printf.sprintf "cp %s %s" src dest in
  (* if not (Sys.file_exists dest) then *)
  Unix.system command |> ignore

let rec list_last_is x l =
  begin match l with
  | [] -> false
  | [ y ] -> x = y
  | e :: l -> list_last_is x l
  end

let ismd file =
  String.split_on_char '.' file
  |> list_last_is "md"

let rec list_beginning l =
  begin match l with
  | [] -> []
  | [ x ] -> []
  | e :: l -> e :: list_beginning l
  end

let fname file =
  String.split_on_char '.' file
  |> list_beginning
  |> String.concat "."
