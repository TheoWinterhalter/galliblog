%token EOF
%token COLON SLASH COMMA
%token TITLE AUTHORS DATE
%token <string> STRING
%token <int> INT
%token <string> CONTENT

%start <Article_ast.t> file
%%

file:
  | l = value_list ; c = CONTENT ; EOF { (List.rev l, c) }
  ;

value_list:
  | (* Empty list *) { [] }
  | vl = value_list ; TITLE ; COLON ; title = STRING { Article_ast.Title title :: vl }
  | vl = value_list ; AUTHORS ; COLON ; authors = string_list { Article_ast.Authors authors :: vl }
  | vl = value_list ; DATE ; COLON ; d = INT ; SLASH ; m = INT ; SLASH ; y = INT { Article_ast.Date (d, m, y) :: vl }
  ;

string_list:
  | (* empty *) { [] }
  | pl = string_list ; COMMA ; path = STRING { path :: pl }
