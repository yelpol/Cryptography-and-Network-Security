# Symetryczny protokół szyfrowania
> (działa w sieci między dwoma urządzeniami, wykorzystuje bibliotekę `openssl`)

## Definicji symboli
* *E* - algorytm szyfrowania
* *D* - algorytm deszyfrowania
* *K* - klucz
* *M* - wiadomość (tekst jawny)
* *C* - szyfrogram

## I etap "Przygotowania":
**Alice i Bob**
1. Ustalają *(E, D)*, mają dwa szyfry do wyboru: *DES* i *AES_128_CBC*
2. Ustalają wspólny sekret *S* za pomocą protokołu Diffiego-Hellmana
3. Generują klucz tajny *K* z sekretu *S*

## II etap "Szyfrowanie":
**Alice**
1. Ustala *M* (plik z dysku)
2. Oblicza *C = E<sub>k</sub>(M)*
3. Wysyła *C* do Boba

## III etap "Deszyfrowanie":
**Bob**
1. Oblicza *M = D<sub>k</sub>(C)*
