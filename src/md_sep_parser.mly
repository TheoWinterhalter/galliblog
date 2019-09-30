%token NL
%token EOF
%token <string> QUOTE
%token <string * string> CODE
%token <Markdown_ast.level * string> H
%token <int * string> OL
%token <string> UL
%token <string> P
%token <string * string * string option> REF

%start <Markdown_ast.pre list> file
%%

file:
  | q = quote ; f = file { BlockQuote q :: f }
  | c = CODE ; f = file { PCode (fst c, snd c) :: f }
  | h = H ; f = file { PHeader (fst h, snd h) :: f }
  | ol = OL ; f = file { OrderedList (fst ol, [ snd ol ]) :: f }
  | s = UL ; f = file { UnorderedList [s] :: f }
  | s = P ; f = file { PParagraph s :: f }
  | r = REF ; f = file { let (r, u, t) = r in PReference (r, u, t) :: f }
  | NL+ ; f = file { f }
  | EOF { [] }
  ;

quote:
  | s = QUOTE ; NL+ ; q = quote { s ^ q }
  | s = QUOTE { s }
  ;
