%token EOF
%token NL
%token SQBL SQBR TILDA UNDERSCORE STAR BANG COLON QUOTE
%token <string * string> CODEBLOCK
%token <string> INLINECODE
%token <string> STRING
%token <string> HD1
%token <string> HD2
%token <string> HD3
%token <string> HD4
%token <string> HD5
%token <string> HD6

%start <Markdown_ast.t> file
%%

file:
  | c = CODEBLOCK ; f = file { Markdown_ast.(Code { lang = fst c ; code = snd c }) :: f }
  | h = HD1 ; f = file { Markdown_ast.(Header (H1, [Raw h])) :: f } (* TODO Parse h, how? *)
  | h = HD2 ; f = file { Markdown_ast.(Header (H2, [Raw h])) :: f } (* TODO Parse h, how? *)
  | h = HD3 ; f = file { Markdown_ast.(Header (H3, [Raw h])) :: f } (* TODO Parse h, how? *)
  | h = HD4 ; f = file { Markdown_ast.(Header (H4, [Raw h])) :: f } (* TODO Parse h, how? *)
  | h = HD5 ; f = file { Markdown_ast.(Header (H5, [Raw h])) :: f } (* TODO Parse h, how? *)
  | h = HD6 ; f = file { Markdown_ast.(Header (H6, [Raw h])) :: f } (* TODO Parse h, how? *)
  | r = reference ; f = file { Markdown_ast.Reference r :: f }
  | p = paragraph ; f = file { Markdown_ast.Paragraph p :: f }
  | EOF { [] }
  ;

reference:
  (* TODO STRING is probably not ok because of symbols forbidden, _ for instance *)
  | SQBL ; pointer = STRING ; SQBR ; COLON ; uri = STRING ; NL { Markdown_ast.({ pointer ; link = { uri ; title = None }}) }
  | SQBL ; pointer = STRING ; SQBR ; COLON ; uri = STRING ; QUOTE ; title = STRING ; QUOTE ; NL { Markdown_ast.({ pointer ; link = { uri ; title = Some title }}) }
  ;

paragraph:
  | t = text ; NL ; NL+ { t }
  | t = text ; NL* ; { t }
  ;

text:
  | e = text_el ; t = text { e :: t }
  | { [] }
  ;

(* TODO Do correct interpretations.
   Some stuff like bold/italic/strikethrough should probably be handled
   by the lexer...
 *)
text_el:
  | s = STRING { Markdown_ast.Raw s }
  | i = INLINECODE { Markdown_ast.InlineCode i }
  | SQBL { Markdown_ast.Raw "[" }
  | SQBR { Markdown_ast.Raw "]" }
  | TILDA { Markdown_ast.Raw "~" }
  | UNDERSCORE { Markdown_ast.Raw "_" }
  | STAR { Markdown_ast.Raw "*" }
  | BANG { Markdown_ast.Raw "!" }
  | COLON { Markdown_ast.Raw ":" }
  | QUOTE { Markdown_ast.Raw "\"" }
  ;
