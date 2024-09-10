type t

val prazen_avtomat : Stanje.t -> t
val dodaj_stanje : Stanje.t -> t -> t
val dodaj_prehod : Stanje.t -> char -> Stanje.t -> t -> t
val dodaj_izhod : Stanje.t -> string -> t -> t
val prehodna_funkcija : t -> Stanje.t -> char -> Stanje.t option
val izhodna_funkcija : t -> Stanje.t -> string option
val zacetno_stanje : t -> Stanje.t
val seznam_stanj : t -> Stanje.t list
val seznam_prehodov : t -> (Stanje.t * char * Stanje.t) list
val seznam_izhodov: t -> (Stanje.t * string) list
val logika : t
val preberi_niz : t -> Stanje.t -> string -> Stanje.t * string option list