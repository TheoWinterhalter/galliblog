%token EOF
%token SHARP
%token SQBL SQBR TILDA UNDERSCORE STAR BANG
%token <string * string> CODEBLOCK
%token <string> INLINECODE
%token <string> STRING

%start <Markdown_ast.t> file
%%

file:
  | c = CODEBLOCK ; f = file { Code { lang = fst c ; code = snd c } :: f }
  | EOF { [] }
  ;
