open Definicije
open Avtomat

type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | BranjeNiza
  | RezultatPrebranegaNiza
  | OpozoriloONapacnemNizu
  | MenjavaOperacije

type model = {
  avtomat : t;
  stanje_avtomata : Stanje.t;
  stanje_vmesnika : stanje_vmesnika;
  operacija : logicna_operacija;
}

type msg =
  | PreberiNiz of string
  | ZamenjajVmesnik of stanje_vmesnika
  | VrniVPrvotnoStanje
  | TrenutnoStanje
  | IzberiOperacijo of logicna_operacija

let capture_operation () =
  print_endline "Izberite logično operacijo (1: IN, 2: ALI, 3: EKSKLUZIVNI ALI, 4: IMPLIKACIJA, 5: EKVIVALENCA):";
  print_string "> ";
  let operation = match read_line () with
    | "1" -> In
    | "2" -> Ali
    | "3" -> EksAli
    | "4" -> Impl
    | "5" -> Ekv
    | _ ->
        print_endline "Neveljavna izbira, privzeto je IN.";
        In
  in
  Printf.printf "Izbrana operacija: %s\n" 
    (match operation with In -> "IN" | Ali -> "ALI" | EksAli -> "EKSKLUZIVNI ALI" | Impl -> "IMPLIKACIJA" | Ekv -> "EKVIVALENCA");
  operation


let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with
    | None -> None
    | Some q -> Avtomat.prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q)

let update model = function
  | PreberiNiz str -> (
      match preberi_niz model.avtomat model.stanje_avtomata str with
      | None -> { model with stanje_vmesnika = OpozoriloONapacnemNizu }
      | Some stanje_avtomata ->
          {
            model with
            stanje_avtomata;
            stanje_vmesnika = RezultatPrebranegaNiza;
          })
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }
  | VrniVPrvotnoStanje ->
      {
        model with
        stanje_avtomata = zacetno_stanje model.avtomat;
        stanje_vmesnika = SeznamMoznosti;
      }
  | TrenutnoStanje ->
      let stanje = Stanje.v_niz model.stanje_avtomata in
      let izhod = Avtomat.izhodna_funkcija model.avtomat model.stanje_avtomata in
      let izpis_izhoda = match izhod with
        | Some s -> s
        | None -> "no output"
      in
      Printf.printf "Trenutno stanje: %s : %s\n" stanje izpis_izhoda;
      { model with stanje_vmesnika = SeznamMoznosti }
  | IzberiOperacijo operacija ->
      { 
        model with 
        operacija; 
        avtomat = logika operacija;
        stanje_vmesnika = SeznamMoznosti 
      }

let rec izpisi_moznosti () =
  print_endline "1) izpiši avtomat";
  print_endline "2) beri znake";
  print_endline "3) nastavi na začetno stanje";
  print_endline "4) trenutno stanje";
  print_endline "5) izberi binarno operacijo";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik BranjeNiza
  | "3" -> VrniVPrvotnoStanje
  | "4" -> TrenutnoStanje
  | "5" -> ZamenjajVmesnik MenjavaOperacije
  | _ ->
      print_endline "** VNESI 1, 2, 3, 4 ALI 5 **";
      izpisi_moznosti ()

let izpisi_avtomat avtomat trenutni_stanje =
  let izpisi_stanje stanje =
    let prikaz = Stanje.v_niz stanje in
    let prikaz =
      if stanje = trenutni_stanje then "-> " ^ prikaz else prikaz
    in
    let izhod = Avtomat.izhodna_funkcija avtomat stanje in
    let prikaz = prikaz ^ " : " ^ (
      match izhod with
        | Some s -> s
        | None -> "no output"
        )
    in
    print_endline prikaz
  in
  List.iter izpisi_stanje (seznam_stanj avtomat)


let beri_niz _model =
  print_string "Vnesi niz > ";
  let str = read_line () in
  PreberiNiz str

let izpisi_rezultat model =
  let izhod = Avtomat.izhodna_funkcija model.avtomat model.stanje_avtomata in
  let prikaz = (
    match izhod with
    | Some s -> s
    | None -> "ni izhoda"
    )
  in
  print_endline prikaz

  let view model =
    match model.stanje_vmesnika with
    | SeznamMoznosti -> 
        izpisi_moznosti ()
    | IzpisAvtomata ->
        izpisi_avtomat model.avtomat model.stanje_avtomata;
        ZamenjajVmesnik SeznamMoznosti
    | BranjeNiza -> beri_niz model
    | RezultatPrebranegaNiza ->
        izpisi_rezultat model;
        ZamenjajVmesnik SeznamMoznosti
    | OpozoriloONapacnemNizu ->
        print_endline "Niz ni veljaven";
        ZamenjajVmesnik SeznamMoznosti
    | MenjavaOperacije -> IzberiOperacijo (capture_operation ())
  

let init avtomat =
  {
    avtomat;
    stanje_avtomata = zacetno_stanje avtomat;
    stanje_vmesnika = SeznamMoznosti;
    operacija = Avtomat.In
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let _ = loop (init (logika Avtomat.In))
