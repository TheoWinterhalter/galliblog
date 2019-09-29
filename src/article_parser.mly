%token EOF
%token COLON SLASH COMMA
%token TITLE AUTHORS DATE
%token <string> STRING
%token <string> QSTRING
%token <int> INT
%token <string> CONTENT

%start <Article_ast.t> file
%%

file:
  | l = value_list ; c = CONTENT { (List.rev l, c) }
  ;

value_list:
  | (* Empty list *) { [] }
  | vl = value_list ; TITLE ; COLON ; title = QSTRING
    { Article_ast.Title title :: vl }
  | vl = value_list ; AUTHORS ; COLON ; authors = ne_qstring_list
    { Article_ast.Authors (List.rev authors) :: vl }
  | vl = value_list ; DATE ; COLON ; d = INT ; SLASH ; m = INT ; SLASH ; y = INT
    { Article_ast.Date (d, m, y) :: vl }
  ;

ne_qstring_list:
  | qs = QSTRING { [ qs ] }
  | qsl = ne_qstring_list ; COMMA ; qs = QSTRING { qs :: qsl }
