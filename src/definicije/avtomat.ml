type stanje = Stanje.t

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  prehodi : (stanje * char * stanje) list;
  izhod : (stanje * string) list
}

type logicna_operacija = In | Ali | EksAli

let operacija_v_funkcijo = function
  | In -> (&&)  (* AND *)
  | Ali -> (||)  (* OR *)
  | EksAli -> (fun a b -> (a || b) && not (a && b))  (* XOR *)



let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    prehodi = [];
    izhod = [];
  }

  let dodaj_stanje stanje avtomat =
    if List.exists ((=) stanje) avtomat.stanja then
      avtomat
    else
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

let logika operacija =
  let s00 = Stanje.iz_niza "s00"
  and s01 = Stanje.iz_niza "s01"
  and s10 = Stanje.iz_niza "s10"
  and s11 = Stanje.iz_niza "s11" in

  let binarna_op = operacija_v_funkcijo operacija in

  (* Define bool mappings for each state *)
let izracunaj_izhod stanje =
  if stanje == s00 then binarna_op false false
  else if stanje == s01 then binarna_op false true
  else if stanje == s10 then binarna_op true false
  else if stanje == s11 then binarna_op true true
  else false

  in

  (* Convert bool result to string *)
  (* let izhod_to_string stanje = if izracunaj_izhod stanje then "1" else "0" in *)

  let izhod_to_string stanje =
    let output = izracunaj_izhod stanje in
    (* Printf.printf "Stanje: %s, Izhod: %b\n" (Stanje.v_niz stanje) output; *)
    if output then "1" else "0" in
  (* Construct the automaton with the correct outputs for each state *)
  prazen_avtomat s00
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
  |> dodaj_izhod s00 (izhod_to_string s00)
  |> dodaj_izhod s01 (izhod_to_string s01)
  |> dodaj_izhod s10 (izhod_to_string s10)
  |> dodaj_izhod s11 (izhod_to_string s11)




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