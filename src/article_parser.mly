%token EOF
%token COLON SLASH COMMA
%token TITLE AUTHORS DATE DEFAULT LANGUAGE UPDATED
%token <string> QSTRING
%token <string> STRING
%token <int> INT
%token <string> CONTENT

%start <Article_ast.t> file
%%

file:
  | l = value_list ; c = maybe_content { (List.rev l, c) }
  ;

maybe_content:
  | c = CONTENT { c }
  | EOF { "" }

value_list:
  | (* Empty list *) { [] }
  | vl = value_list ; TITLE ; COLON ; title = QSTRING
    { Article_ast.Title title :: vl }
  | vl = value_list ; AUTHORS ; COLON ; authors = ne_qstring_list
    { Article_ast.Authors (List.rev authors) :: vl }
  | vl = value_list ; DATE ; COLON ; d = INT ; SLASH ; m = INT ; SLASH ; y = INT
    { Article_ast.Date (d, m, y) :: vl }
  | vl = value_list ; DEFAULT ; LANGUAGE ; COLON ; s = STRING
    { Article_ast.Default_language s :: vl }
  | vl = value_list ; DEFAULT ; LANGUAGE ; COLON ; s = QSTRING
    { Article_ast.Default_language s :: vl }
  | vl = value_list ; UPDATED ; COLON ; d = INT ; SLASH ; m = INT ; SLASH ; y = INT
    { Article_ast.Updated (d, m, y) :: vl }
  ;

ne_qstring_list:
  | qs = QSTRING { [ qs ] }
  | qsl = ne_qstring_list ; COMMA ; qs = QSTRING { qs :: qsl }
