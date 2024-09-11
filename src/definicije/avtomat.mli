type stanje = Stanje.t
type logicna_operacija = In | Ali | EksAli | Impl | Ekv

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  prehodi : (stanje * char * stanje) list;
  izhod : (stanje * string) list
}

val operacija_v_funkcijo : logicna_operacija -> (bool -> bool -> bool)
val prazen_avtomat : stanje -> t
val dodaj_stanje : stanje -> t -> t
val dodaj_prehod : stanje -> char -> stanje -> t -> t
val dodaj_izhod : stanje -> string -> t -> t
val prehodna_funkcija : t -> stanje -> char -> stanje option
val izhodna_funkcija : t -> stanje -> string option
val zacetno_stanje : t -> stanje
val seznam_stanj : t -> stanje list
val seznam_prehodov : t -> (stanje * char * stanje) list
val seznam_izhodov : t -> (stanje * string) list
val logika : logicna_operacija -> t
val preberi_niz : t -> stanje -> string -> (stanje * string option list)
