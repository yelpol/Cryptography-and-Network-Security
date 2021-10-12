#Protokół ślepego podpisu (100 wiadomości)

## I etap "Generowanie klucza publicznego":
**Bob-klient**
1. Tworzy klucz publiczny RSA i wysyła do Alice

## II etap "Podpisywanie":
**Alice-server**
1. Pobiera klucz publiczny Boba
2. Przygotowuje 100 wiadomości *M<sub>i</sub>, i = 1..100*
4. Oblicza hash do wszystkich wiadomości *h<sub>i</sub> = H(M<sub>i</sub>), i = 1..100*
5. Zakrywa wszystkie haszy *y<sub>i</sub> = h<sub>i</sub> * k<sub>i</sub>^e(mod n)* (*k<sub>i</sub> jest liczbą losową*)
6. Wysyła wszystkie zakryte wiadomości do Boba

## III etap "Wybór wiadomości do podpisu":
**Bob**
1. Odbiera zakryte wiadomości
2. Losuje *j, 1 <= j <= n* i wysyła do Alice

## IV etap "Odkrycie wiadomości, weryfikacja":
**Alice**
1. Pobiera *j*
2. Wysyła wszystkie wiadomości *M<sub>i</sub>, i = 1..100, i != j* i wszystkie *k<sub>i</sub> i = 1..100, i != j*

**Bob**
1. Oblicza *h<sub>i</sub> i= 1..100, i != j*
2. Odkrywa wiadomości *h'<sub>i</sub> = y<sub>i</sub> * k<sub>i</sub>^-e mod n*
3. Porównuje czy *h<sub>i</sub>* równe do *h'<sub>i</sub>* dla *i = 1..100, i != j*
4. Jeśli weryfikacja przechodzi, podpisuje ślepą wiadomość *z = SIG(y<sub>j</sub>)* i wysyła do Alice


## V etap "Odkrywanie podpisu":
**Alice**
1. Odbiera ślepą podpisaną wiadomość *z*
2. Odkrywa podpis
