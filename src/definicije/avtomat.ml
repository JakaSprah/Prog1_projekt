type stanje = Stanje.t

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  prehodi : (stanje * char * stanje) list;
  izhod : (stanje * string) list
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    prehodi = [];
    izhod = [];
  }

let dodaj_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_prehod stanje1 znak stanje2 avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2) :: avtomat.prehodi }

let dodaj_izhod stanje izhod avtomat =
  { avtomat with izhod = (stanje, izhod) :: avtomat.izhod }

let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None
  | Some (_, _, stanje2) -> Some stanje2

let izhodna_funkcija avtomat stanje = 
  match
    List.find_opt
      (fun (stanje', _izhod) -> stanje = stanje')
      avtomat.izhod
  with
  | None -> None
  | Some (_, izhod) -> Some izhod

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi
let seznam_izhodov avtomat = avtomat.izhod
let logika =
  let s00 = Stanje.iz_niza "00"
  and s01 = Stanje.iz_niza "01"
  and s10 = Stanje.iz_niza "10"
  and s11 = Stanje.iz_niza "11" in
  prazen_avtomat s00
  |> dodaj_stanje s00
  |> dodaj_stanje s01
  |> dodaj_stanje s10
  |> dodaj_stanje s11
  |> dodaj_prehod s00 '0' s00
  |> dodaj_prehod s00 '1' s01
  |> dodaj_prehod s01 '0' s10
  |> dodaj_prehod s01 '1' s11
  |> dodaj_prehod s10 '0' s00
  |> dodaj_prehod s10 '1' s01
  |> dodaj_prehod s11 '0' s10
  |> dodaj_prehod s11 '1' s11
  |> dodaj_izhod s00 "0"
  |> dodaj_izhod s01 "0"
  |> dodaj_izhod s10 "0"
  |> dodaj_izhod s11 "1"


let preberi_niz avtomat zacetno_stanje niz =
  let rec aux stanje acc_izhodov vhod =
    match vhod with
    | [] -> stanje, List.rev acc_izhodov
    | znak :: ostalo ->
      match prehodna_funkcija avtomat stanje znak with
      | None -> stanje, List.rev acc_izhodov
      | Some novo_stanje ->
        let izhod = izhodna_funkcija avtomat novo_stanje in
        aux novo_stanje (izhod :: acc_izhodov) ostalo
  in
  aux zacetno_stanje [] (niz |> String.to_seq |> List.of_seq)