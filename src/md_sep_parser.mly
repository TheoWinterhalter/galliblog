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
  | NL* ; f = no_nl_file { f }
  ;

no_nl_file:
  | q = quote ; f = no_nl_file { Markdown_ast.BlockQuote q :: f }
  | c = CODE ; f = file { Markdown_ast.PCode (fst c, snd c) :: f }
  | h = H ; f = file { Markdown_ast.PHeader (fst h, snd h) :: f }
  | ol = OL ; f = file { Markdown_ast.OrderedList (fst ol, [ snd ol ]) :: f }
  | s = UL ; f = file { Markdown_ast.UnorderedList [s] :: f }
  | s = P ; f = file { Markdown_ast.PParagraph s :: f }
  | r = REF ; f = file { let (r, u, t) = r in Markdown_ast.PReference (r, u, t) :: f }
  | EOF { [] }
  ;

quote:
  | s = QUOTE ; NL ; q = quote { s ^ "\n" ^ q }
  | s = QUOTE { s }
  ;
