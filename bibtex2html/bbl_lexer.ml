# 21 "bbl_lexer.mll"
 

open Lexing

exception End_of_biblio

let opt_ref = ref None

let key = ref ""

let brace_depth = ref 0

let buf = Buffer.create 1024


# 18 "bbl_lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\253\255\254\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\001\000\001\000\001\000\002\000\000\000\
    \002\000\000\000\006\000\000\000\000\000\000\000\009\000\000\000\
    \000\000\001\000\001\000\255\255\002\000\254\255\003\000\255\255\
    \022\000\025\000\253\255\030\000\056\000\082\000\108\000\185\000\
    \211\000\002\000\015\000\019\000\024\000\126\000\134\000\125\000\
    \129\000\124\000\133\000\123\000\141\000\127\000\136\000\120\000\
    \117\000\255\255\238\000\008\001\034\001\060\001\086\001\112\001\
    \000\000\255\255\198\001\252\255\253\255\000\000\255\255\254\255\
    \120\000\255\255\199\001\252\255\253\255\001\000\255\255\254\255\
    \227\001\251\255\002\000\000\000\254\255\003\000\255\255\253\255\
    \252\255\006\000\254\255\011\000";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\002\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\001\000\255\255\
    \255\255\255\255\255\255\002\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\001\000\
    \255\255\255\255\255\255\255\255\255\255\002\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\002\000\255\255\255\255\
    \255\255\255\255\004\000\004\000\255\255\004\000\255\255\255\255\
    \255\255\255\255\255\255\000\000";
  Lexing.lex_default =
   "\001\000\000\000\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\026\000\000\000\029\000\000\000\032\000\000\000\
    \032\000\034\000\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\068\000\000\000\000\000\255\255\000\000\000\000\
    \255\255\000\000\076\000\000\000\000\000\255\255\000\000\000\000\
    \081\000\000\000\255\255\255\255\000\000\255\255\000\000\000\000\
    \000\000\090\000\000\000\255\255";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\071\000\079\000\088\000\086\000\000\000\091\000\
    \091\000\000\000\091\000\091\000\091\000\091\000\000\000\091\000\
    \091\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\087\000\091\000\000\000\
    \000\000\000\000\000\000\091\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\065\000\003\000\030\000\000\000\000\000\
    \031\000\021\000\004\000\013\000\015\000\005\000\012\000\006\000\
    \011\000\007\000\014\000\017\000\016\000\019\000\008\000\018\000\
    \022\000\023\000\020\000\031\000\010\000\035\000\042\000\043\000\
    \044\000\024\000\045\000\009\000\026\000\025\000\027\000\036\000\
    \037\000\036\000\036\000\038\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\037\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\037\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\058\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\037\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\039\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\046\000\
    \047\000\048\000\049\000\050\000\051\000\052\000\053\000\054\000\
    \055\000\056\000\057\000\073\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\255\255\255\255\255\255\000\000\000\000\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\255\255\000\000\
    \000\000\255\255\036\000\037\000\036\000\040\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\037\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\041\000\036\000\
    \059\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\037\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\060\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\059\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\061\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\037\000\036\000\
    \036\000\062\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \037\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\063\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\037\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\069\000\077\000\085\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \082\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\070\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\083\000\
    \000\000\000\000\000\000\000\000\078\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\067\000\075\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\084\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\069\000\077\000\082\000\085\000\255\255\089\000\
    \089\000\255\255\089\000\089\000\091\000\091\000\255\255\091\000\
    \091\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\083\000\089\000\255\255\
    \255\255\255\255\255\255\091\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\064\000\000\000\028\000\255\255\255\255\
    \030\000\020\000\003\000\012\000\014\000\004\000\011\000\005\000\
    \010\000\006\000\013\000\016\000\015\000\018\000\007\000\017\000\
    \021\000\022\000\019\000\032\000\009\000\033\000\041\000\042\000\
    \043\000\023\000\044\000\008\000\025\000\024\000\026\000\035\000\
    \035\000\035\000\035\000\035\000\035\000\035\000\035\000\035\000\
    \035\000\035\000\035\000\035\000\035\000\035\000\035\000\035\000\
    \035\000\035\000\035\000\035\000\035\000\035\000\035\000\035\000\
    \035\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\038\000\038\000\038\000\
    \038\000\038\000\038\000\038\000\038\000\038\000\038\000\038\000\
    \038\000\038\000\038\000\038\000\038\000\038\000\038\000\038\000\
    \038\000\038\000\038\000\038\000\038\000\038\000\038\000\045\000\
    \046\000\047\000\048\000\049\000\050\000\051\000\052\000\053\000\
    \054\000\055\000\056\000\072\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\026\000\028\000\030\000\255\255\255\255\089\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\032\000\255\255\
    \255\255\033\000\039\000\039\000\039\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\039\000\039\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\039\000\039\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\039\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\058\000\
    \058\000\058\000\058\000\058\000\058\000\058\000\058\000\058\000\
    \058\000\058\000\058\000\058\000\058\000\058\000\058\000\058\000\
    \058\000\058\000\058\000\058\000\058\000\058\000\058\000\058\000\
    \058\000\059\000\059\000\059\000\059\000\059\000\059\000\059\000\
    \059\000\059\000\059\000\059\000\059\000\059\000\059\000\059\000\
    \059\000\059\000\059\000\059\000\059\000\059\000\059\000\059\000\
    \059\000\059\000\059\000\060\000\060\000\060\000\060\000\060\000\
    \060\000\060\000\060\000\060\000\060\000\060\000\060\000\060\000\
    \060\000\060\000\060\000\060\000\060\000\060\000\060\000\060\000\
    \060\000\060\000\060\000\060\000\060\000\061\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\061\000\061\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\061\000\061\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\061\000\061\000\061\000\062\000\
    \062\000\062\000\062\000\062\000\062\000\062\000\062\000\062\000\
    \062\000\062\000\062\000\062\000\062\000\062\000\062\000\062\000\
    \062\000\062\000\062\000\062\000\062\000\062\000\062\000\062\000\
    \062\000\063\000\063\000\063\000\063\000\063\000\063\000\063\000\
    \063\000\063\000\063\000\063\000\063\000\063\000\063\000\063\000\
    \063\000\063\000\063\000\063\000\063\000\063\000\063\000\063\000\
    \063\000\063\000\063\000\066\000\074\000\080\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \080\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\066\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\080\000\
    \255\255\255\255\255\255\255\255\074\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\066\000\074\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\080\000";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec biblio_header lexbuf =
   __ocaml_lex_biblio_header_rec lexbuf 0
and __ocaml_lex_biblio_header_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 39 "bbl_lexer.mll"
      ( biblio_name lexbuf )
# 268 "bbl_lexer.ml"

  | 1 ->
# 41 "bbl_lexer.mll"
      ( raise End_of_file )
# 273 "bbl_lexer.ml"

  | 2 ->
# 43 "bbl_lexer.mll"
      ( biblio_header lexbuf )
# 278 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_biblio_header_rec lexbuf __ocaml_lex_state

and biblio_name lexbuf =
   __ocaml_lex_biblio_name_rec lexbuf 28
and __ocaml_lex_biblio_name_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 47 "bbl_lexer.mll"
      ( let l = lexeme lexbuf in
	let s = String.sub l 1 (String.length l - 2) in
        Some s )
# 292 "bbl_lexer.ml"

  | 1 ->
# 51 "bbl_lexer.mll"
      ( None )
# 297 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_biblio_name_rec lexbuf __ocaml_lex_state

and bibitem lexbuf =
   __ocaml_lex_bibitem_rec lexbuf 33
and __ocaml_lex_bibitem_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 55 "bbl_lexer.mll"
      ( raise End_of_biblio )
# 309 "bbl_lexer.ml"

  | 1 ->
# 57 "bbl_lexer.mll"
      ( brace_depth := 0;
	begin try bibitem1 lexbuf
	      with Failure _ -> opt_ref := None end;
        bibitem2 lexbuf )
# 317 "bbl_lexer.ml"

  | 2 ->
# 61 "bbl_lexer.mll"
      ( bibitem lexbuf )
# 322 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem_rec lexbuf __ocaml_lex_state

and bibitem1 lexbuf =
   __ocaml_lex_bibitem1_rec lexbuf 64
and __ocaml_lex_bibitem1_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 64 "bbl_lexer.mll"
        ( Buffer.reset buf; opt_ref := Some (bibitem1_body lexbuf) )
# 334 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem1_rec lexbuf __ocaml_lex_state

and bibitem1_body lexbuf =
   __ocaml_lex_bibitem1_body_rec lexbuf 66
and __ocaml_lex_bibitem1_body_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 67 "bbl_lexer.mll"
          ( Buffer.contents buf )
# 346 "bbl_lexer.ml"

  | 1 ->
# 68 "bbl_lexer.mll"
          ( bibitem1_body lexbuf )
# 351 "bbl_lexer.ml"

  | 2 ->
# 69 "bbl_lexer.mll"
          ( Buffer.add_char buf (lexeme_char lexbuf 0); bibitem1_body lexbuf )
# 356 "bbl_lexer.ml"

  | 3 ->
# 70 "bbl_lexer.mll"
          ( raise End_of_file )
# 361 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem1_body_rec lexbuf __ocaml_lex_state

and bibitem2 lexbuf =
   __ocaml_lex_bibitem2_rec lexbuf 72
and __ocaml_lex_bibitem2_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 73 "bbl_lexer.mll"
        ( Buffer.reset buf;
	  key := bibitem2_body lexbuf;
	  skip_end_of_line lexbuf;
	  Buffer.reset buf;
	  bibitem_body lexbuf )
# 377 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem2_rec lexbuf __ocaml_lex_state

and bibitem2_body lexbuf =
   __ocaml_lex_bibitem2_body_rec lexbuf 74
and __ocaml_lex_bibitem2_body_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 80 "bbl_lexer.mll"
          ( Buffer.contents buf )
# 389 "bbl_lexer.ml"

  | 1 ->
# 81 "bbl_lexer.mll"
          ( bibitem2_body lexbuf )
# 394 "bbl_lexer.ml"

  | 2 ->
# 82 "bbl_lexer.mll"
          ( Buffer.add_char buf (lexeme_char lexbuf 0); bibitem2_body lexbuf )
# 399 "bbl_lexer.ml"

  | 3 ->
# 83 "bbl_lexer.mll"
          ( raise End_of_file )
# 404 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem2_body_rec lexbuf __ocaml_lex_state

and bibitem_body lexbuf =
   __ocaml_lex_bibitem_body_rec lexbuf 80
and __ocaml_lex_bibitem_body_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 87 "bbl_lexer.mll"
      ( let s = Buffer.contents buf in (!opt_ref, !key, s) )
# 416 "bbl_lexer.ml"

  | 1 ->
# 89 "bbl_lexer.mll"
      ( raise End_of_file )
# 421 "bbl_lexer.ml"

  | 2 ->
# 90 "bbl_lexer.mll"
          ( Buffer.add_string buf "\\%"; bibitem_body lexbuf )
# 426 "bbl_lexer.ml"

  | 3 ->
# 91 "bbl_lexer.mll"
          ( bibitem_body lexbuf )
# 431 "bbl_lexer.ml"

  | 4 ->
# 92 "bbl_lexer.mll"
          ( Buffer.add_char buf (lexeme_char lexbuf 0); bibitem_body lexbuf )
# 436 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_bibitem_body_rec lexbuf __ocaml_lex_state

and skip_end_of_line lexbuf =
   __ocaml_lex_skip_end_of_line_rec lexbuf 89
and __ocaml_lex_skip_end_of_line_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 96 "bbl_lexer.mll"
      ( () )
# 448 "bbl_lexer.ml"

  | 1 ->
# 97 "bbl_lexer.mll"
      ( skip_end_of_line lexbuf )
# 453 "bbl_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_skip_end_of_line_rec lexbuf __ocaml_lex_state

;;

