(** Markdown file AST *)

(** Link *)
type link = {
  uri : string ;
  title : string option
}

(** Source in markdown file *)
type source =
| Direct of link
| Ref of string

(** Reference in markdown file *)
type reference = {
  pointer : string ;
  link : link
}

(** Markdown image *)
type img = {
  alt_text : string ;
  img_ref : source
}

(** Markdown rich text *)
type text_el =
| Raw of string
| Italic of text
| Bold of text
| Strike of text
| Img of img
| Link of anchor
| InlineCode of string

(** Markdown rich text *)
and text = text_el list

(** Anchor *)
and anchor = {
  a_txt : text ;
  a_ref : source
}

(** Header level *)
type level = H1 | H2 | H3 | H4 | H5 | H6

(** Code block *)
type code_block = {
  lang : string ;
  code : string
}

(** Markdown AST element *)
type el =
| Paragraph of text
| Header of level * text
| Code of code_block
| Reference of reference

(** Markdown AST *)
type t = el list

(** Markdown first-pass AST *)
type pre =
| BlockQuote of string
| PHeader of level * string
| PCode of string * string
| OrderedList of int * string list
| UnorderedList of string list
| PReference of string * string * string option
| PParagraph of string
