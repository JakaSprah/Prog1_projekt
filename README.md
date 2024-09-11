# Moorovi avtomati

Projekt vsebuje implementacijo Moorovih avtomatov pri analiziranju dvojiških nizov z logičnimi operacijami. 

## Opis

Moorov avtomat je končni avtomat z izhodom, odvisnim od trenutnega stanja. Vhodni podatki ne vplivajo neposredno na izhod, temveč na prehode med stanji. Moorovi avtomati se imenujejo po ameriškem matematiku in računalničarju, ki je koncept opisal leta 1956. 

## Formalna definicija

Formalno je Moorov avtomat definiran kot nabor s šestimi elementi $(S, s_0, \Sigma, O, \delta, G)$, kjer so:

- $S$ končna množica stanj,
- $s_0 \in S$ začetno stanje,
- $\Sigma$ končna množica oz. abeceda vhodov,
- $O$ končna množica oz. abeceda izhodov,
- $\delta : S \times \Sigma \to Q$ prehodna funkcija,
- $G : S \to O$ izhodna funkcija.

## Primer implementacije

Naš primer Moorovega avtomata analizira nize iz ničel in enic. Vmesnik od uporabnika sprejema po en simbol, ki je bodisi "0", ki predstavlja neresnico (false) ali "1", ki predstavlja resnico (true). Glede na zadnja dva sprejeta simbola se avtomat premika med štirimi možnimi stanji. Izhodna funkcija izvede logično operacijo na nizu ničel in enic. Privzeta operacija je konjukcija oz. logični "in", uporabnik pa lahko operacijo tudi spreminja, kar vpliva na izhodno funkcijo. Tudi izhod je podan z ničlo ali enico.

- $S = ${$s_{00}$, $s_{10}$, $s_{01}$, $s_{11}$},
- $s_0 = s_{00}$,
- $\Sigma$ = {0, 1},
- $O$ = {0, 1},
- $\delta : S \times \Sigma \to S$ je podana s tabelo:

    | $\delta$ | `0`    | `1`   | 
    | -------- | -----  | ----- | 
    | $s_{00}$   | $s_{00}$ | $s_{01}$ | 
    | $s_{10}$   | $s_{00}$ | $s_{01}$ | 
    | $s_{01}$   | $s_{10}$ | $s_{11}$ | 
    | $s_{11}$   | $s_{10}$ | $s_{11}$ | 

- Funkcijo $G$ določa resničnostna tabela izbrane logične operacije. Stanje s_{10} funkcija na primer interpretira kot nabor $(1, 0)$ oz. $(true, false)$, na teh dveh logičnih vrednostih pa izvede trenutno izbrano logično operacijo. Za operacijo "in" je tabela funkcije G sledeča:

    | stanje |  $G$  |
    | -------| ----- |
    | $s_{00}$ | $0$ | 
    | $s_{10}$ | $0$ | 
    | $s_{01}$ | $0$ | 
    | $s_{11}$ | $1$ | 

## Navodila za uporabo

Avtomat uporabljamo s pomočjo ukazov, ki jih vpisujemo v terminal. Tekstovni vmesnik prevedemo z ukazom `dune build`, ki ustvari datoteko `tekstovniVmesnik.exe`. Ukaz `./tekstovniVmesnik.exe.exe` datoteko požene. Med izvajanjem programa sledimo navodilom v terminalu. Na vsakem koraku izvajanja imamo pet možnosti:
- izpis avtomata,
- branje znakov,
- ponastavitev avtomata v začetno stanje,
- prikaz trenutnega stanja,
- izbira binarne logične operacije.

Z vpisom pripadajoče številke izberemo ukaz, ki ga želimo izvesti.


## Struktura datotek

Projekt je sestavljen iz map `src` in `definicije`, ki vsebujeta naslednje datoteke:
- `avtomat.ml`: definira strukturo Mealyjevega avtomata,
- `stanje.ml`: definira tip stanja,
- `tekstovniVmesnik.ml`: vmesnik za analizo dvojiških nizov s pomočjo terminala.


# Končni avtomati

Projekt vsebuje implementacijo končnih avtomatov, enega najpreprostejših računskih modelov, ter njihovo uporabo pri karakterizaciji nizov. Končni avtomat začne v enem izmed možnih stanj, nato pa glede na trenutno stanje in trenutni simbol preide v neko novo stanje. Če ob pregledu celotnega niza konča v enem od sprejemnih stanj, je niz sprejet, sicer pa ni.

Za tekoči primer si oglejmo avtomat, ki sprejema nize, sestavljene iz ničel in enic, v katerih da vsota enic pri deljenju s 3 ostanek 1. Tak avtomat predstavimo z naslednjim diagramom, na katerem je začetno stanje označeno s puščico, sprejemna stanja pa so dvojno obkrožena.

TODO

## Matematična definicija

Končni avtomat je definiran kot nabor $(\Sigma, Q, q_0, F, \delta)$, kjer so:

- $\Sigma$ množica simbolov oz. abeceda,
- $Q$ množica stanj,
- $q_0 \in Q$ začetno stanje,
- $F \subseteq Q$ množica sprejemnih stanj in
- $\delta : Q \times \Sigma \to Q$ prehodna funkcija.

Na primer, zgornji končni avtomat predstavimo z naborom $(\{0, 1\}, \{q_0, q_1, q_2\}, q_0, \{q_1\}, \delta)$, kjer je $\delta$ podana z naslednjo tabelo:

| $\delta$ | `0`   | `1`   |
| -------- | ----- | ----- |
| $q_0$    | $q_0$ | $q_1$ |
| $q_1$    | $q_2$ | $q_0$ |
| $q_2$    | $q_1$ | $q_2$ |

## Navodila za uporabo

Ker projekt služi kot osnova za večje projekte, so njegove lastnosti zelo okrnjene. Konkretno implementacija omogoča samo zgoraj omenjeni končni avtomat. Na voljo sta dva vmesnika, tekstovni in grafični. Oba prevedemo z ukazom `dune build`, ki v korenskem imeniku ustvari datoteko `tekstovniVmesnik.exe`, v imeniku `html` pa JavaScript datoteko `spletniVmesnik.bc.js`, ki se izvede, ko v brskalniku odpremo `spletniVmesnik.html`.

Če OCamla nimate nameščenega, lahko še vedno preizkusite tekstovni vmesnik prek ene od spletnih implementacij OCamla, najbolje <http://ocaml.besson.link/>, ki podpira branje s konzole. V tem primeru si na vrh datoteke `tekstovniVmesnik.ml` dodajte še vrstice

```ocaml
module Avtomat = struct
    (* celotna vsebina datoteke avtomat.ml *)
end
```

### Tekstovni vmesnik

TODO

### Spletni vmesnik

TODO

## Implementacija

### Struktura datotek

TODO

### `avtomat.ml`

TODO

### `model.ml`

TODO
